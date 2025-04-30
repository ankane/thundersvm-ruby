module ThunderSVM
  class Model
    def initialize(svm_type: :c_svc, kernel: :rbf, degree: 3, gamma: nil, coef0: 0,
      c: 1, nu: 0.5, epsilon: 0.1, max_memory: 8192, tolerance: 0.001,
      probability: false, gpu: 0, cores: nil, verbose: nil)

      @svm_type = svm_type.to_sym
      @kernel = kernel.to_sym
      @degree = degree
      @gamma = gamma
      @coef0 = coef0
      @c = c
      @nu = nu
      @epsilon = epsilon
      @max_memory = max_memory
      @tolerance = tolerance
      @probability = probability
      @gpu = gpu
      @cores = cores
      @verbose = verbose
    end

    def fit(x, y = nil)
      train(x, y)
    end

    def cv(x, y = nil, folds: 5)
      train(x, y, folds: folds)
    end

    def predict(x)
      dataset_file = create_dataset(x)
      out_file = create_tempfile
      argv = ["thundersvm-predict", dataset_file.path, @model_file.path, out_file.path]
      FFI.thundersvm_predict(argv.size, str_ptr(argv))
      func = [:c_svc, :nu_svc].include?(@svm_type) ? :to_i : :to_f
      out_file.each_line.map(&func)
    end

    def save_model(path)
      raise Error, "Not trained" unless @model_file
      FileUtils.cp(@model_file.path, path)
      nil
    end

    def load_model(path)
      @model_file ||= create_tempfile
      # TODO ensure tempfile is still cleaned up
      FileUtils.cp(path, @model_file.path)
      @svm_type = read_header["svm_type"].to_sym
      @kernel = read_header["kernel_type"].to_sym
      nil
    end

    def support_vectors
      vectors = []
      sv = false
      read_txt do |line|
        if sv
          index = line.index("1:")
          vectors << line[index..-1].split(" ").map { |v| v.split(":").last.to_f }
        elsif line.start_with?("SV")
          sv = true
        end
      end
      vectors
    end

    def dual_coef
      vectors = []
      sv = false
      read_txt do |line|
        if sv
          index = line.index("1:")
          line[0...index].split(" ").map(&:to_f).each_with_index do |v, i|
            (vectors[i] ||= []) << v
          end
        elsif line.start_with?("SV")
          sv = true
        end
      end
      vectors
    end

    def self.finalize_file(file)
      # must use proc instead of stabby lambda
      proc do
        file.close
        file.unlink
      end
    end

    private

    def train(x, y = nil, folds: nil)
      dataset_file = create_dataset(x, y)
      @model_file ||= create_tempfile

      svm_types = {
        c_svc: 0,
        nu_svc: 1,
        one_class: 2,
        epsilon_svr: 3,
        nu_svr: 4
      }
      s = svm_types[@svm_type]
      raise Error, "Unknown SVM type: #{@svm_type}" unless s

      kernels = {
        linear: 0,
        polynomial: 1,
        rbf: 2,
        sigmoid: 3
      }
      t = kernels[@kernel]
      raise Error, "Unknown kernel: #{@kernel}" unless t

      verbose = @verbose
      verbose = true if folds && verbose.nil?

      argv = ["thundersvm-train"]
      argv += ["-s", s]
      argv += ["-t", t]
      argv += ["-d", @degree.to_i] if @degree
      argv += ["-g", @gamma.to_f] if @gamma
      argv += ["-r", @coef0.to_f] if @coef0
      argv += ["-c", @c.to_f] if @c
      argv += ["-n", @nu.to_f] if @nu
      argv += ["-p", @epsilon.to_f] if @epsilon
      argv += ["-m", @max_memory.to_i] if @max_memory
      argv += ["-e", @tolerance.to_f] if @tolerance
      argv += ["-b", @probability ? 1 : 0] if @probability
      argv += ["-v", folds.to_i] if folds
      argv += ["-u", @gpu.to_i] if @gpu
      argv += ["-o", @cores.to_i] if @cores
      argv << "-q" unless verbose
      argv += [dataset_file.path, @model_file.path]

      FFI.thundersvm_train(argv.size, str_ptr(argv))
      nil
    end

    def create_dataset(x, y = nil)
      if x.is_a?(String)
        raise ArgumentError, "Cannot pass y with file" if y
        File.open(x)
      else
        contents = String.new("")
        y ||= [0] * x.size
        x.to_a.zip(y.to_a).each do |xi, yi|
          contents << "#{yi.to_i} #{xi.map.with_index { |v, i| "#{i + 1}:#{v.to_f}" }.join(" ")}\n"
        end
        dataset = create_tempfile
        dataset.write(contents)
        dataset.close
        dataset
      end
    end

    def str_ptr(arr)
      ptr = Fiddle::Pointer.malloc(Fiddle::SIZEOF_VOIDP * arr.size, Fiddle::RUBY_FREE)
      str_ptrs = arr.map { |v| Fiddle::Pointer["#{v}\x00"] }
      str_ptrs.each_with_index do |v, i|
        ptr[i * Fiddle::SIZEOF_VOIDP, Fiddle::SIZEOF_VOIDP] = v.ref
      end
      ptr.instance_variable_set(:@thundersvm_refs, str_ptrs)
      ptr
    end

    def create_tempfile
      file = Tempfile.new("thundersvm")
      ObjectSpace.define_finalizer(self, self.class.finalize_file(file))
      file
    end

    def read_header
      model = {}
      read_txt do |line|
        break if line.start_with?("SV")
        k, v = line.split(" ", 2)
        model[k] = v.strip
      end
      model
    end

    def read_txt
      @model_file.rewind
      @model_file.each_line do |line|
        yield line
      end
    end
  end
end

module ThunderSVM
  module FFI
    extend Fiddle::Importer

    libs = ThunderSVM.ffi_lib.dup
    begin
      dlload libs.shift
    rescue Fiddle::DLError => e
      retry if libs.any?
      raise e if ENV["THUNDERSVM_DEBUG"]
      raise LoadError, "Could not find ThunderSVM"
    end

    extern "void thundersvm_train(int argc, char **argv)"
    extern "void thundersvm_train_after_parse(char **option, int len, char *file_name)"
    extern "void thundersvm_predict(int argc, char **argv)"
    extern "void thundersvm_predict_after_parse(char *model_file_name, char *output_file_name, char **option, int len)"
  end
end

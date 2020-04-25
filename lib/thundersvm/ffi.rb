module ThunderSVM
  module FFI
    extend Fiddle::Importer

    libs = Array(ThunderSVM.ffi_lib).dup
    begin
      dlload Fiddle.dlopen(libs.shift)
    rescue Fiddle::DLError => e
      retry if libs.any?

      if e.message.include?("Library not loaded: /usr/local/opt/libomp/lib/libomp.dylib") && e.message.include?("Reason: image not found")
        raise Fiddle::DLError, "OpenMP not found. Run `brew install libomp`"
      else
        raise e
      end
    end

    extern "void thundersvm_train(int argc, char **argv)"
    extern "void thundersvm_train_after_parse(char **option, int len, char *file_name)"
    extern "void thundersvm_predict(int argc, char **argv)"
    extern "void thundersvm_predict_after_parse(char *model_file_name, char *output_file_name, char **option, int len)"
  end
end

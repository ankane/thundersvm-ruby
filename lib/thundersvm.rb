# stdlib
require "fiddle/import"
require "fileutils"
require "tempfile"

# modules
require_relative "thundersvm/model"
require_relative "thundersvm/classifier"
require_relative "thundersvm/regressor"
require_relative "thundersvm/version"

module ThunderSVM
  class Error < StandardError; end

  class << self
    attr_accessor :ffi_lib
  end
  lib_name =
    if Gem.win_platform?
      "thundersvm.dll"
    elsif RbConfig::CONFIG["host_os"] =~ /darwin/i
      if RbConfig::CONFIG["host_cpu"] =~ /arm|aarch64/i
        "libthundersvm.arm64.dylib"
      else
        "libthundersvm.dylib"
      end
    else
      "libthundersvm.so"
    end
  vendor_lib = File.expand_path("../vendor/#{lib_name}", __dir__)
  self.ffi_lib = [vendor_lib]

  # friendlier error message
  autoload :FFI, "thundersvm/ffi"

  def self.load_model(path)
    model = Model.new
    model.load_model(path)
    model
  end
end

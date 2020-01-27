# stdlib
require "fiddle/import"
require "fileutils"
require "tempfile"

# modules
require "thundersvm/model"
require "thundersvm/classifier"
require "thundersvm/regressor"
require "thundersvm/version"

module ThunderSVM
  class Error < StandardError; end

  class << self
    attr_accessor :ffi_lib
  end
  lib_name =
    if Gem.win_platform?
      "thundersvm.dll"
    elsif RbConfig::CONFIG["host_os"] =~ /darwin/i
      "libthundersvm.dylib"
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

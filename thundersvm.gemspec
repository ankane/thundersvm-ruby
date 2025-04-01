require_relative "lib/thundersvm/version"

Gem::Specification.new do |spec|
  spec.name          = "thundersvm"
  spec.version       = ThunderSVM::VERSION
  spec.summary       = "High performance parallel SVMs for Ruby"
  spec.homepage      = "https://github.com/ankane/thundersvm-ruby"
  spec.license       = "Apache-2.0"

  spec.author        = "Andrew Kane"
  spec.email         = "andrew@ankane.org"

  spec.files         = Dir["*.{md,txt}", "{lib,vendor}/**/*"]
  spec.require_path  = "lib"

  spec.required_ruby_version = ">= 3.2"

  spec.add_dependency "fiddle"
end

require_relative "lib/thundersvm/version"

Gem::Specification.new do |spec|
  spec.name          = "thundersvm"
  spec.version       = ThunderSVM::VERSION
  spec.summary       = "ThunderSVM - high-performance parallel SVMs - for Ruby"
  spec.homepage      = "https://github.com/ankane/thundersvm"
  spec.license       = "Apache-2.0"

  spec.author        = "Andrew Kane"
  spec.email         = "andrew@chartkick.com"

  spec.files         = Dir["*.{md,txt}", "{lib,vendor}/**/*"]
  spec.require_path  = "lib"

  spec.required_ruby_version = ">= 2.4"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest", ">= 5"
  spec.add_development_dependency "numo-narray" unless ENV["APPVEYOR"]
end

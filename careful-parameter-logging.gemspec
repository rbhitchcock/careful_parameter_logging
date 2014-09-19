# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'careful_parameter_logging/version'

Gem::Specification.new do |spec|
  spec.name          = "careful_parameter_logging"
  spec.version       = CarefulParameterLogging::VERSION
  spec.authors       = ["Blake Hitchcock"]
  spec.email         = ["rbhitchcock@gmail.com"]
  spec.summary       = %q{Keep your log files clean.}
  spec.description   = %q{Scrub potentially sensitive parameters before logging}
  spec.homepage      = "https://github.com/rbhitchcock/careful_parameter_logging"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end

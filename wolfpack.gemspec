# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wolfpack/version'

Gem::Specification.new do |spec|
  spec.name          = "wolfpack"
  spec.version       = Wolfpack::VERSION
  spec.authors       = ["Brad Gessler"]
  spec.email         = ["brad@polleverywhere.com"]
  spec.description   = %q{Run stuff in parallel}
  spec.summary       = %q{Run ruby tasks in parallel}
  spec.homepage      = "https://github.com/polleverywhere/wolfpack"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "guard-rspec"

  spec.add_dependency "thor"
  spec.add_dependency "facter"
end

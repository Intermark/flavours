# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'flavours/version'

Gem::Specification.new do |spec|
  spec.name          = "flavours"
  spec.version       = Flavours::VERSION
  spec.authors       = ["Ben Gordon"]
  spec.email         = ["brgordon@ua.edu"]
  spec.description   = "One codebase. Multiple Google Play Store submission APKs with different buildConfigs, package names, icons, etc."
  spec.summary       = "Fast Product Flavor creation for Android."
  spec.homepage      = "https://github.com/intermark/flavours"
  spec.license       = "MIT"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency 'bundler', '~> 1.3'
  spec.add_dependency 'fileutils'
  spec.add_dependency 'commander', '~> 4.2'
  spec.add_dependency 'dotenv', '~> 0.11'
  spec.add_dependency 'rmagick', '~> 2.13.2'
  spec.add_dependency 'json'

  spec.files         = Dir["./**/*"].reject { |file| file =~ /\.\/(bin|log|pkg|script|spec|test|vendor|(.*?)\.gem)/ }
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.require_paths = ["lib"]
end

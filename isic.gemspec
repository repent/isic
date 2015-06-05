# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'isic/version'

Gem::Specification.new do |spec|
  spec.name          = "isic"
  spec.version       = Isic::VERSION
  spec.authors       = ["Javier Vidal"]
  spec.email         = ["javier@javiervidal.net"]
  spec.summary       = 'International Standard Industrial Classification'
  spec.description   = 'The International Standard Industrial Classification (ISIC) is a United Nations system for classifying economic data. The classification is based in four hierarchical levels: sections, divisions, groups and classes. This gem allows to classify an entity based on its ISIC code.'
  spec.homepage      = "https://github.com/javiervidal/isic"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "awesome_print"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "pry"
end

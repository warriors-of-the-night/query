# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'query/version'

Gem::Specification.new do |spec|
  spec.name          = "query"
  spec.version       = Query::VERSION
  spec.authors       = ["seoaqua"]
  spec.email         = ["seoaqua@me.com"]
  spec.description   = %q{This GEM is designed to work for SEOers who need to fetch query and parse results from all kinds of search engines}
  spec.summary       = %q{Now its only support Chinese main search engines}
  spec.homepage      = "https://github.com/seoaqua/query"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_dependency "nokogiri"
  spec.add_dependency "addressable"
  spec.add_dependency "httparty"
  spec.add_dependency "awesome_print"
end

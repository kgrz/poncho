# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'poncho/version'

Gem::Specification.new do |gem|
  gem.name          = "poncho"
  gem.version       = Poncho::VERSION
  gem.authors       = ["Alex MacCaw"]
  gem.email         = ["alex@stripe.com"]
  gem.description   = %q{Poncho is an API to build REST APIs with a convenient DSL.}
  gem.summary       = %q{Poncho is an API to build APIs}
  gem.homepage      = "https://github.com/stripe/poncho"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'multi_json', '~> 1.8.5'
end

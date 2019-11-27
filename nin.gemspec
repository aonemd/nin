# coding: utf-8
require File.expand_path('../lib/nin/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors     = ["Ahmed Saleh"]
  gem.email       = 'aonemdsaleh@gmail.com'
  gem.description = "A simple, full-featured command line todo app"
  gem.summary     = "A command line todo app that provides an easy to use CLI for everyday todo management"
  gem.homepage    = 'https://github.com/aonemd/nin'

  gem.files         = `git ls-files`.split($\).reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.executables   = ["nin"]

  gem.name    = 'nin'
  gem.version = Nin::VERSION
  gem.license = 'MIT'

  gem.add_dependency 'toml-rb'
  gem.add_dependency 'chronic'
  gem.add_dependency 'colored2'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'byebug'
  gem.add_development_dependency 'minitest'
end

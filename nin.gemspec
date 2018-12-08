# coding: utf-8

Gem::Specification.new do |gem|
  gem.authors     = ["Ahmed Saleh"]
  gem.email       = 'aonemdsaleh@gmail.com'
  gem.description = "Under construction"
  gem.summary     = "Under construction"
  gem.homepage    = 'https://github.com/aonemd/nin'

  gem.files         = `git ls-files`.split($\).reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.executables   = ["nin"]

  gem.name        = 'nin'
  gem.version     = '0.0.0'
  gem.license     = 'MIT'

  gem.add_dependency 'toml-rb'

  gem.add_development_dependency 'byebug'
  gem.add_development_dependency 'minitest'
end

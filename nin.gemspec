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

  gem.name        = 'nin'
  gem.version     = '0.0.0'
  gem.files       = ["lib/nin.rb"]
  gem.license     = 'MIT'
end

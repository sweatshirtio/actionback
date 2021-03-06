$:.push File.expand_path('../lib', __FILE__)

require 'actionback/version'

Gem::Specification.new do |s|
  s.name        = 'actionback'
  s.version     = ActionBack::VERSION
  s.authors     = ['Ari Summer']
  s.email       = ['aribsummer@gmail.com']
  s.homepage    = 'https://github.com/sweatshirtio/actionback'
  s.summary     = 'actionpack with back'
  s.description = 'Deserialize URLs to resources or resource IDs. Great for Hypermedia APIs.'
  s.license     = 'MIT'

  s.files       = `git ls-files -- lib/*`.split("\n")
  s.files      += %w[README.md MIT-LICENSE]
  s.test_files  = []

  s.add_dependency "rails", ">= 3.0"

  s.add_development_dependency "rspec", "~> 3.1.0"
  s.add_development_dependency "guard-rspec"
end

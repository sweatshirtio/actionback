$:.push File.expand_path("../lib", __FILE__)

require "actionback/version"

Gem::Specification.new do |s|
  s.name        = "actionback"
  s.version     = ActionBack::VERSION
  s.authors     = ["Ari Summer"]
  s.email       = ["aribsummer@gmail.com"]
  s.homepage    = "https://github.com/sweatshirtio/actionback"
  s.summary     = "actionpack with back"
  s.description = "Deserialize URLs to resources or resource IDs. Great for Hypermedia APIs."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.6"

  s.add_development_dependency "sqlite3"
end

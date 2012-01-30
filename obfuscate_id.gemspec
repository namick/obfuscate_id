$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "obfuscate_id/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "obfuscate_id"
  s.version     = ObfuscateId::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of ObfuscateId."
  s.description = "TODO: Description of ObfuscateId."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.2.1"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "capybara"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "guard-spork"
end

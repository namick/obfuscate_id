$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "obfuscate_id/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "obfuscate_id"
  s.version     = ObfuscateId::VERSION
  s.authors     = ["Nathan Amick"]
  s.email       = ["github@nathanamick.com"]
  s.homepage    = ""
  s.summary     = "A simple Rails plugin that lightly masks seqential ActiveRecord ids"
  s.description = "ObfuscateId is a simple Ruby on Rails plugin that hides your seqential Active Record ids.  Although having nothing to do with security, it can be used to make database record id information non-obvious."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 3.2.1"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "capybara"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "guard-spork"
  s.add_development_dependency "rb-inotify"
end

$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "obfuscate_id/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "obfuscate_id"
  s.version     = ObfuscateId::VERSION
  s.authors     = ["Nathan Amick"]
  s.email       = ["github@nathanamick.com"]
  s.summary     = "Mask ActiveRecord IDs"
  s.description = "Make your ActiveRecord IDs non-obvious"
  s.homepage    = "https://github.com/namick/obfuscate_id"
  s.licenses    = ['MIT', 'GPL-2']

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "scatter_swap",    "~> 0.0.3"
  s.add_dependency "rails",           ">= 4.2.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "capybara"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "guard-spork"
  s.add_development_dependency "rb-inotify"
  s.add_development_dependency "pry"
  s.add_development_dependency "launchy"
end

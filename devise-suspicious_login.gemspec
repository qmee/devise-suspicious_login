$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "devise/suspicious_login/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "devise-suspicious_login"
  s.version     = Devise::SuspiciousLogin::VERSION
  s.authors     = ["ceres629"]
  s.email       = ["ceres629@gmail.com"]
  s.summary     = "Devise extension that check for suspicious logins"
  s.summary     = "Devise extension that check for suspicious logins"

  s.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.md"]

  s.add_dependency "devise", "~> 4"
  s.add_development_dependency "rake"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rails", "~> 5.1.2"
  s.add_development_dependency "capybara", "~> 3.6.0"
end

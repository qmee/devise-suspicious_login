$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require "suspicious_login/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "devise-suspicious_login"
  s.version     = SuspiciousLogin::VERSION.dup
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["ceres629"]
  s.email       = ["ceres629@gmail.com"]
  s.summary     = "Devise extension that check for suspicious logins"
  s.summary     = "Devise extension that check for suspicious logins"
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.require_paths = ['lib']

  s.add_runtime_dependency "devise", ">= 4"
  s.add_development_dependency "colorize"
  s.add_development_dependency 'rails', '>= 5.0'
  s.add_development_dependency 'minitest'
  s.add_development_dependency "rake"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "factory_bot_rails"
end

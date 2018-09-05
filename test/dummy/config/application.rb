require_relative 'boot'

require 'rails/all'
require 'jwt'
require 'devise'
require "devise/suspicious_login"
require "action_mailer/railtie"


Bundler.require(*Rails.groups)

module RailsApp
  class Application < Rails::Application
    config.encoding = 'utf-8'
    config.filter_parameters += [:password]
    config.assets.enabled = true
    config.assets.version = '1.0'
    config.secret_key_base = 'change_me'
  end
end


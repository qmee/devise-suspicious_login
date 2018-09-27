require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)
require "suspicious_login"

module Dummy
  class Application < Rails::Application
    config.active_record.sqlite3.represent_boolean_as_integer = true
    config.encoding = 'utf-8'
    config.filter_parameters += [:password]
    config.assets.enabled = true
    config.assets.version = '1.0'
    config.secret_key_base = 'change_me'
  end
end

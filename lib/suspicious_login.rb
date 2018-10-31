module SuspiciousLogin
  autoload :Schema, 'suspcious_login/schema'
  autoload :Patches, 'suspicious_login/patches'
  autoload :Mailer, 'suspicious_login/mailer'

  class MissingModelError < StandardError; end
  class DeviseMissingFromModel < StandardError; end
end

require 'devise'
require 'suspicious_login/model'
require 'suspicious_login/rails'
require 'suspicious_login/strategies/token'
require 'colorize'

module Devise
  mattr_accessor :expire_login_token_after
  @@expire_login_token_after = 10.minutes

  mattr_accessor :resend_login_token_after
  @@resend_login_token_after = 1.minute

  mattr_accessor :dormant_sign_in_after
  @@dormant_sign_in_after = 3.months

  mattr_accessor :token_field_name
  @@token_field_name = :login_token

  mattr_accessor :token_created_at_field_name
  @@token_created_at_field_name = :login_token_sent_at

  mattr_accessor :clear_token_on_login
  @@clear_token_on_login = true

  mattr_accessor :trigger_strategies
  @@trigger_strategies = ["Devise::Strategies::DatabaseAuthenticatable"]
end

I18n.load_path.unshift File.join(File.dirname(__FILE__), *%w[suspicious_login locales en.yml])

Devise.add_module :suspicious_login, model: "suspicious_login/model"

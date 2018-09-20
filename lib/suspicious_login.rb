module SuspiciousLogin
  autoload :Schema, 'suspcious_login/schema'
  autoload :Patches, 'suspicious_login/patches'
  autoload :Mailer, 'suspicious_login/mailer'
end

require 'devise'
require 'suspicious_login/model'
require 'suspicious_login/rails'

module Devise
  mattr_accessor :expire_login_token_after
  @@expire_login_token_after = 10.minutes

  mattr_accessor :resend_login_token_after
  @@resend_login_token_after = 1.minute

  mattr_accessor :dormant_sign_in_after
  @@dormant_sign_in_after = 3.months

  mattr_accessor :suspicious_login_home_page
  @@suspicious_login_home_page = nil
end

I18n.load_path.unshift File.join(File.dirname(__FILE__), *%w[suspicious_login locales en.yml])

Devise.add_module :suspicious_login, model: "suspicious_login/model"

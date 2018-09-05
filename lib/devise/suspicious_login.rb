require 'devise'
require 'devise/suspicious_login/model'
require 'jwt'

module Devise
  mattr_accessor :expire_token_after
  @@expire_token_after = 10.minutes

  mattr_accessor :dormant_sign_in_after
  @@dormant_sign_in_after = 3.months

  mattr_accessor :suspicious_login_method
  @@suspicious_login_method = -> { false }

  mattr_accessor :jwt_secret
  @@jwt_secret = "change_me"

  module SuspiciousLogin
  end
end

Devise.add_module :suspicious_login, model: "devise/suspicious_login/model"
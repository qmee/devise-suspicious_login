require 'devise'
require 'devise/suspicious_login/model'

module Devise
  mattr_accessor :expire_token_after
  @@expire_token_after = 10.minutes

  mattr_accessor :dormant_sign_in_after
  @@dormant_sign_in_after = 3.months

  mattr_accessor :suspicious_login_method
  @@suspicious_login_method = -> { false }

  module SuspiciousLogin
  end
end

Devise.add_module :suspicious_login, model: "devise/suspicious_login/model"
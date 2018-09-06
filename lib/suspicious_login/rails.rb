require 'suspicious_login'

module SuspiciousLogin
  class Engine < ::Rails::Engine
    ActiveSupport::Reloader.to_prepare do
      SuspiciousLogin::Patches.apply
    end
  end
end
require "devise/suspicious_login/hooks/suspicious_login"

module JWT_
  require "jwt"

  def self.encode(data, secret)
    JWT.encode(data, secret)
  end
end

module Devise
  module Models
    module SuspiciousLogin
      extend ActiveSupport::Concern

      def suspicious_login?
        send_suspicious_login_instructions
        if (dormant_account?)
          send_suspicious_login_instructions
          return true
        end

        return false
      end

      def send_suspicious_login_instructions
        data = {
          :email => email,
          :exp => 15.minutes.from_now.utc.to_i
        }

        jwt = JWT_.encode(data, Devise.jwt_secret)
        send_devise_notification(:suspicious_login_instructions, jwt, {})
      end

      private

      def dormant_account?
        Time.now - last_sign_in_at > Devise.dormant_sign_in_after
      end
    end
  end
end

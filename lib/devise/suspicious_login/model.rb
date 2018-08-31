require "devise/suspicious_login/hooks/suspicious_login"

module Devise
  module Models
    module SuspiciousLogin
      extend ActiveSupport::Concern

      def suspicious_login?
        return dormant_account? || Devise.suspicious_login_method.call
      end

      private

      def dormant_account?
        Time.now - last_sign_in_at > Devise.dormant_sign_in_after
      end
    end
  end
end
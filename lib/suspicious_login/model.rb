require "suspicious_login/hooks/suspicious_login"

module Devise
  module Models
    module SuspiciousLogin
      extend ActiveSupport::Concern

      def suspicious?(request = {})
        respond_to?(:suspicious_login_attempt?) ? suspicious_login_attempt?(request) || dormant_account? : dormant_account?
      end

      def send_suspicious_login_instructions
        send_devise_notification(:suspicious_login_instructions, nil, {})
      end

      def dormant_account?
        respond_to?(:last_sign_in_at) &&
        !last_sign_in_at.nil? &&
        last_sign_in_ip != current_sign_in_ip &&
        Time.now.utc - last_sign_in_at > Devise.dormant_sign_in_after
      end
    end
  end
end

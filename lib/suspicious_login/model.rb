require "suspicious_login/hooks/suspicious_login"

module Devise
  module Models
    module SuspiciousLogin
      extend ActiveSupport::Concern

      def self.required_fields(klass)
        [Devise.token_field_name, Devise.token_created_at_field_name]
      end

      def generate_login_token
        loop do
          token = Devise.friendly_token
          break token unless User.where(authentication_token: token).first
        end
      end

      def generate_reset_password_token
        raw, enc = Devise.token_generator.generate(self.class, :reset_password_token)
        self.reset_password_token = enc
        self.reset_password_sent_at = Time.now.utc
        raw
      end

      def reset_suspicious_login_token(token=nil)
        token = token || generate_login_token
        self[Devise.token_field_name] = token
        self[Devise.token_created_at_field_name] = Time.now.utc unless Devise.expire_login_token_after.blank?
        token
      end

      def generate_reset_password_token!
        token = generate_reset_password_token
        save(validate: false)
        token
      end

      def reset_suspicious_login_token!(token=nil)
        token = reset_suspicious_login_token(token)
        save(validate: false)
        token
      end

      def clear_suspicious_login_token!
        self[Devise.token_field_name] = nil
        self[Devise.token_created_at_field_name] = nil
        save(validate: false)
      end

      def after_login_token_authentication
        clear_suspicious_login_token! if Devise.clear_token_on_login
        @token_login = true
      end

      def suspicious?(request = {})
        respond_to?(:suspicious_login_attempt?) ? suspicious_login_attempt?(request) || dormant_account? : dormant_account?
      end

      def send_suspicious_login_instructions
        send_devise_notification(:suspicious_login_instructions, nil, {})
      end

      def token_login?
        @token_login || false
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

require "suspicious_login/hooks/suspicious_login"

module Devise
  module Models
    module SuspiciousLogin
      extend ActiveSupport::Concern

      module ClassMethods
        def login_token
          loop do
            token = Devise.friendly_token
            break token unless to_adapter.find_first(Hash[Devise.token_field_name, token])
          end
        end

      end

      def generate_reset_password_token!
        raw, enc = Devise.token_generator.generate(self.class, :reset_password_token)
        reset_password_token = enc
        reset_password_sent_at = Time.now.utc
        save(validate: false)
      end

      def reset_suspicious_login_token(token=nil)
        self[Devise.token_field_name] = token || self.class.login_token
        self[Devise.token_created_at_field_name] = Time.now.utc unless Devise.expire_login_token_after.blank?
      end

      def reset_suspicious_login_token!(token=nil)
        reset_suspicious_login_token(token)
        save(validate: false)
      end

      def ensure_suspicious_login_token(token=nil)
        reset_suspicious_login_token(token) if self[token_field_name].blank?
      end

      def ensure_suspicious_login_token!(token=nil)
        reset_suspicious_login_token!(token) if self[token_field_name].blank?
      end

      def after_login_token_authentication
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

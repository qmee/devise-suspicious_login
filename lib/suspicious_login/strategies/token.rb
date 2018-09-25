require 'devise/strategies/base'

module Devise
  module Strategies
    class SecureTokenAuthenticatable < Authenticatable
      def store?
        super
      end

      def valid?
        resource_email.present? && login_token.present?
      end

      def authenticate!
        resource = resource_email && mapping.to.find_by(:email => resource_email)

        if resource && Devise.secure_compare(resource[Devise.token_field_name], login_token)
          resource.after_login_token_authentication
          success!(resource)
        else
          Devise.secure_compare("foo", login_token)
          fail!
        end
      end

      private

      def valid_params_request?
        true
      end

      def resource
        @resource ||= mapping.to.find_by(:email => params)
      end

      def resource_email
        @email ||= params[:email]
      end

      def login_token
        @login_token ||= params[:login_token]
      end

      def token_expires_after
        @token_expires_after ||= Devise.token_expires_after
      end
    end
  end
end

Warden::Strategies.add(:suspicious_login_token, Devise::Strategies::SecureTokenAuthenticatable)
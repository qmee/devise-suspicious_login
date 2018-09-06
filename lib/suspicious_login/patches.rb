require 'suspicious_login/mailer'

module SuspiciousLogin
  module Patches
    class << self
      def apply
        Devise.mailer.send(:include, SuspiciousLogin::Mailer)
        Devise.mailer.send(:include, Devise::Mailers::Helpers) unless Devise.mailer.ancestors.include?(Devise::Mailers::Helpers)
      end
    end
  end
end
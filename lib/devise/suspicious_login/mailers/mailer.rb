# class Devise::Mailer < Devise.parent_mailer.constantize
#   include Devise::Mailers::Helpers

#   def suspicious_login_instructions(record, unlock_token, opts={})
#     @record = record
#     @unlock_token = ERB::Util.url_encode(unlock_token)
#     devise_mail(record, :suspicious_login_instructions, opts)
#   end
# end

module Devise
  module SuspiciousLogin
    module Mailer
      def suspicious_login_instructions(record, unlock_token, opts={})
        @record = record
        @unlock_token = ERB::Util.url_encode(unlock_token)
        devise_mail(record, :suspicious_login_instructions, opts)
      end
    end
  end
end
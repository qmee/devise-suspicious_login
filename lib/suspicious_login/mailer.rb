module SuspiciousLogin
  module Mailer
    def suspicious_login_instructions(record, token=nil, opts={})
      @record = record

      record.reset_suspicious_login_token!(token)
      @token = ERB::Util.url_encode(record[Devise.token_field_name])
      record.generate_reset_password_token!
      @reset_password_token = record.reset_password_token

      devise_mail(record, :suspicious_login_instructions, opts)
    end
  end
end
module SuspiciousLogin
  module Mailer
    def suspicious_login_instructions(record, token=nil, opts={})
      @record = record
      @token = ERB::Util.url_encode(record.reset_suspicious_login_token!(token))
      @reset_password_token = record.generate_reset_password_token!

      devise_mail(record, :suspicious_login_instructions, opts)
    end
  end
end
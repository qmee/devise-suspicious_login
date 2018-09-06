module SuspiciousLogin
  module Mailer
    def suspicious_login_instructions(record, token, opts={})
      @record = record
      @token = ERB::Util.url_encode(token)
      devise_mail(record, :suspicious_login_instructions, opts)
    end
  end
end
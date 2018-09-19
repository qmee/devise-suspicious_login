module SuspiciousLogin
  module Mailer
    def suspicious_login_instructions(record, token, opts={})
      @record = record
      @token = ERB::Util.url_encode(token)
      raw, @reset_password_token = Devise.token_generator.generate(record.class, :reset_password_token)
      record.login_token = @token
      record.login_token_sent_at = Time.now.utc

      record.reset_password_token   = @reset_password_token
      record.reset_password_sent_at = Time.now.utc
      record.save(validate: false)
      devise_mail(record, :suspicious_login_instructions, opts)
    end
  end
end
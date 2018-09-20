Warden::Manager.after_set_user except: :fetch do |user, warden, opts|
  if user && user.respond_to?(:suspicious?) && user.suspicious?(warden.request)
    user.send_suspicious_login_instructions if user.login_token_sent_at.nil? || Time.now.utc - user.login_token_sent_at > Devise.resend_login_token_after
    scope = opts[:scope]
    warden.logout(scope) if warden.authenticated?(scope)
    throw(:warden, message: I18n.t('devise.failure.invalid'))
  end
end
Warden::Manager.after_fetch do |user, warden, opts|
  scope = opts[:scope]
  if user && user.respond_to?(:suspicious_login?) && !user.suspicious_login?
    p "SUSPICIOUS LOGIN ATTEMPT"
  end
  p "WTF3"
  warden.logout(scope) if warden.authenticated?(scope)
end
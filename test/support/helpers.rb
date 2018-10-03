require 'active_support/test_case'

@@default_ip = '127.0.0.4'

class ActiveSupport::TestCase
  def setup_mailer
    Devise.mailer = Devise::Mailer
    ActionMailer::Base.deliveries = []
  end
end

class ActionDispatch::Request
  def remote_ip
    @@default_ip
  end
end
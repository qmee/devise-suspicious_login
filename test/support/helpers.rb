require 'active_support/test_case'

class ActiveSupport::TestCase
  def setup_mailer
    Devise.mailer = Devise::Mailer
    ActionMailer::Base.deliveries = []
  end
end
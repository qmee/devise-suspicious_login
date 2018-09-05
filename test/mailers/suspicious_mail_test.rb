
class SuspiciousMailTest < ActionMailer::TestCase
  def setup
    setup_mailer
    Devise.mailer = Devise::Mailer
    Devise.mailer_sender = 'test@example.com'
  end

  def user
    password = "password"
    # @user = User.create(id: 2, email: "example_user_02@example.org", password: password, password_confirmation: password, created_at: Time.now, updated_at: Time.now, last_sign_in_at: 1.day.ago)
    # @dormant_user = User.create(id: 3, email: "example_user_03@example.org", password: password, password_confirmation: password, created_at: Time.now, updated_at: Time.now, last_sign_in_at: 1.year.ago)
    @external_suspicious_user = User.create(id: 4, email: "suspicious@example.org", password: password, password_confirmation: password, created_at: Time.now, updated_at: Time.now, last_sign_in_at: 1.day.ago)
    p @external_suspicious_user.suspicious_login?
  end

  def mail
    @mail ||= begin
      user
      p ActionMailer::Base.deliveries
      ActionMailer::Base.deliveries.first
    end
  end

  test 'email sent after suspicious login' do
    assert_not_nil mail
  end
end
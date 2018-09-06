
class SuspiciousMailTest < ActionDispatch::IntegrationTest
  def setup
    setup_mailer
    Devise.mailer = Devise::Mailer
    Devise.mailer_sender = 'test@example.com'
  end

  def honest_user
    password = "password"

    @dormant_user ||= begin
      User.create!(
        id: 1,
        email: "honest@example.org",
        password: password,
        password_confirmation: password,
        created_at: Time.now,
        updated_at: Time.now,
        last_sign_in_at: 1.day.ago
      )
    end
  end

  def dormant_user
    password = "password"

    @dormant_user ||= begin
      User.create!(
        id: 2,
        email: "dormant@example.org",
        password: password,
        password_confirmation: password,
        created_at: Time.now,
        updated_at: Time.now,
        last_sign_in_at: 1.year.ago
      )
    end
  end

  def suspicious_user
    password = "password"

    @suspicious_user ||= begin
      User.create!(
        id: 3,
        email: "suspicious@example.org",
        password: password,
        password_confirmation: password,
        created_at: Time.now,
        updated_at: Time.now,
        last_sign_in_at: 1.day.ago
      )
    end
  end

  def mail
    @mail ||= begin
      ActionMailer::Base.deliveries.first
    end
  end

  test 'email not send after honest user login' do
    user = honest_user

    params = {
      user: {
        email: user.email,
        password: "password"
      }
    }

    post user_session_path, params: params
    assert_redirected_to 'http://www.example.com/'
    assert_nil mail
  end

  test 'email send after dormant login' do
    user = dormant_user

    params = {
      user: {
        email: user.email,
        password: "password"
      }
    }

    post user_session_path, params: params
    assert_redirected_to new_user_session_path
    assert_not_nil mail
    assert_equal "Your email or password are invalid, OR we need to verify your sign in. If you have received an email from us, please follow the instructions to complete your sign in.", flash[:alert]
  end

  test 'email sent after suspicious login' do
    user = suspicious_user

    params = {
      user: {
        email: user.email,
        password: "password"
      }
    }

    post user_session_path, params: params
    assert_redirected_to new_user_session_path
    assert_not_nil mail
    assert_equal "Your email or password are invalid, OR we need to verify your sign in. If you have received an email from us, please follow the instructions to complete your sign in.", flash[:alert]
  end

  test 'email not sent after honest user login with recently sent email' do
    user = honest_user
    user.login_token_sent_at = Time.now
    user.save!

    params = {
      user: {
        email: user.email,
        password: "password"
      }
    }

    post user_session_path, params: params
    assert_redirected_to 'http://www.example.com/'
    assert_nil mail
  end

  test 'email not sent after dormant login with recently sent email' do
    user = dormant_user
    user.login_token_sent_at = Time.now
    user.save!

    params = {
      user: {
        email: user.email,
        password: "password"
      }
    }

    post user_session_path, params: params
    assert_redirected_to new_user_session_path
    assert_nil mail
    assert_equal "Your email or password are invalid, OR we need to verify your sign in. If you have received an email from us, please follow the instructions to complete your sign in.", flash[:alert]
  end

  test 'email not sent after suspicious login with recently sent email' do
    user = suspicious_user
    user.login_token_sent_at = Time.now
    user.save!

    params = {
      user: {
        email: user.email,
        password: "password"
      }
    }

    post user_session_path, params: params
    assert_redirected_to new_user_session_path
    assert_nil mail
    assert_equal "Your email or password are invalid, OR we need to verify your sign in. If you have received an email from us, please follow the instructions to complete your sign in.", flash[:alert]
  end
end
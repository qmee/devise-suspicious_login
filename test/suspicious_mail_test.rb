
class SuspiciousMailTest < ActionDispatch::IntegrationTest
  def setup
    setup_mailer
    Devise.mailer = Devise::Mailer
    Devise.mailer_sender = 'test@example.com'
  end

  def mail
    @mail ||= begin
      ActionMailer::Base.deliveries.first
    end
  end

  test 'new user - email not sent' do
    user = create(:new_user)

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

  test 'user with honest login - email not sent' do
    user = create(:user_with_honest_login)

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

  test 'user with dormant login from same ip - email sent' do
    user = create(:user_with_dormant_login_from_same_ip)

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

  test 'user with dormant login from different ip - email sent' do
    user = create(:user_with_dormant_login_from_different_ip)

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

  test 'user with suspicious login – email not sent' do
    user = create(:user_with_suspicious_login)

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

  test 'user with dormant login from different ip and recently sent login token - email not sent' do
    user = create(:user_with_dormant_login_from_different_ip_and_recently_sent_login_token)

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

  test 'user with suspicious login and recently sent login token - email not sent' do
    user = create(:user_with_suspicious_login_and_recently_sent_login_token)

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

class SuspiciousMailTest < ActionDispatch::IntegrationTest
  def setup
    setup_mailer
    Devise.mailer = Devise::Mailer
    Devise.mailer_sender = 'test@example.com'
    Devise.clear_token_on_login = true
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

  test 'user with suspicious login and no token' do
    user = create(:user_with_suspicious_login_and_recently_sent_login_token)

    get root_path
    assert_redirected_to new_user_session_path
  end

  test 'user with suspicious login and valid token and config.clear_token_on_login=true' do
    Devise.clear_token_on_login = true

    user = create(:user_with_suspicious_login_and_recently_sent_login_token)
    params = {
      login_token: "TOKEN",
      email: user.email
    }
    get root_path(params)
    assert_response :success

    user = User.find(user.id)
    assert_nil user[Devise.token_field_name]
    assert_nil user[Devise.token_created_at_field_name]
  end

  test 'user with suspicious login and valid token and config.clear_token_on_login=false' do
    Devise.clear_token_on_login = false

    user = create(:user_with_suspicious_login_and_recently_sent_login_token)
    params = {
      login_token: "TOKEN",
      email: user.email
    }
    get root_path(params)
    assert_response :success

    user = User.find(user.id)
    assert_equal user[Devise.token_field_name], "TOKEN"
    assert_not_nil user[Devise.token_created_at_field_name]
  end

  test 'user with suspicious login and valid but expired token' do
    Devise.clear_token_on_login = false

    user = create(:user_with_suspicious_login_and_ancient_login_token)
    params = {
      login_token: "TOKEN",
      email: user.email
    }
    get root_path(params)
    assert_redirected_to new_user_session_path

    user = User.find(user.id)
    assert_equal user[Devise.token_field_name], "TOKEN"
    assert_not_nil user[Devise.token_created_at_field_name]
  end

  test 'user with suspicious login and invalid token and config.clear_token_on_login=true' do
    Devise.clear_token_on_login = true

    user = create(:user_with_suspicious_login_and_recently_sent_login_token)
    params = {
      login_token: "WRONG TOKEN",
      email: user.email
    }
    get root_path(params)
    assert_redirected_to new_user_session_path

    user = User.find(user.id)
    assert_equal user[Devise.token_field_name], "TOKEN"
    assert_not_nil user[Devise.token_created_at_field_name]
  end

  test 'user with suspicious login and invalid token and config.clear_token_on_login=false' do
    Devise.clear_token_on_login = false

    user = create(:user_with_suspicious_login_and_recently_sent_login_token)
    params = {
      login_token: "WRONG TOKEN",
      email: user.email
    }
    get root_path(params)
    assert_redirected_to new_user_session_path

    user = User.find(user.id)
    assert_equal user[Devise.token_field_name], "TOKEN"
    assert_not_nil user[Devise.token_created_at_field_name]
  end
end
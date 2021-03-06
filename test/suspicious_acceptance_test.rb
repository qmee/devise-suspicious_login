class SuspiciousMailTest < ActionDispatch::IntegrationTest
  def setup
    setup_mailer
    Devise.mailer = Devise::Mailer
    Devise.mailer_sender = 'test@example.com'
    Devise.clear_token_on_login = true
    @@default_ip = '127.0.0.4'
  end

  def mail
    @mail ||= begin
      ActionMailer::Base.deliveries.first
    end
  end

  test 'new user' do
    user = create(:new_user)

    params = {
      user: {
        email: user.email,
        password: "password"
      }
    }

    post user_session_path, params: params
    assert_redirected_to root_path
    assert_nil mail
  end

  test 'user with honest login' do
    user = create(:user_with_honest_login)

    params = {
      user: {
        email: user.email,
        password: "password"
      }
    }

    post user_session_path, params: params
    assert_redirected_to root_path
    assert_nil mail
  end

  test 'user with dormant login from same ip' do
    user = create(:user_with_dormant_login)

    @@default_ip = '127.0.0.1'
    params = {
      user: {
        email: user.email,
        password: "password"
      }
    }

    post user_session_path, params: params
    assert_redirected_to root_path
    assert_nil mail
  end

  test 'user with dormant login from different ip' do
    user = create(:user_with_dormant_login)

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

  test 'user with suspicious login' do
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

  test 'user with dormant login from different ip and recently sent login token' do
    user = create(:user_with_dormant_login_and_recently_sent_login_token)

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

  test 'user with suspicious login and recently sent login token' do
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

  test 'multiple failed signins does not update trackable data' do
    user = create(:user_with_dormant_login)

    params = {
      user: {
        email: user.email,
        password: "password"
      }
    }

    last_sign_in_at = user.last_sign_in_at
    current_sign_in_at = user.current_sign_in_at
    last_sign_in_ip = user.last_sign_in_ip
    current_sign_in_ip = user.current_sign_in_ip

    post user_session_path, params: params
    assert_redirected_to new_user_session_path
    user.reload
    assert_equal user.last_sign_in_at, last_sign_in_at
    assert_equal user.current_sign_in_at, current_sign_in_at
    assert_equal user.last_sign_in_ip, last_sign_in_ip
    assert_equal user.current_sign_in_ip, current_sign_in_ip

    post user_session_path, params: params
    assert_redirected_to new_user_session_path
    user.reload
    assert_equal user.last_sign_in_at, last_sign_in_at
    assert_equal user.current_sign_in_at, current_sign_in_at
    assert_equal user.last_sign_in_ip, last_sign_in_ip
    assert_equal user.current_sign_in_ip, current_sign_in_ip
  end

  test 'successful login updates trackable fields correctly' do
    user = create(:user_with_honest_login)

    params = {
      user: {
        email: user.email,
        password: "password"
      }
    }

    last_sign_in_at = user.last_sign_in_at
    current_sign_in_at = user.current_sign_in_at
    last_sign_in_ip = user.last_sign_in_ip
    current_sign_in_ip = user.current_sign_in_ip

    post user_session_path, params: params
    assert_redirected_to root_path

    user.reload
    assert_equal user.last_sign_in_at, current_sign_in_at
    assert user.current_sign_in_at > current_sign_in_at
    assert_equal user.last_sign_in_ip, current_sign_in_ip
    assert_equal user.current_sign_in_ip, '127.0.0.4'
  end
end
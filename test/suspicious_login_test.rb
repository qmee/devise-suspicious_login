require_relative 'test_helper.rb'

class SuspiciousLoginIntegrationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'new user' do
    user = create(:new_user)
    assert_equal(user.suspicious?, false)
  end

  test 'user with honest login' do
    user = create(:user_with_honest_login)
    assert_equal(user.suspicious?, false)
  end

  test 'user with dormant login from same ip' do
    user = create(:user_with_dormant_login_from_same_ip)
    assert_equal(user.dormant_account?, false)
  end

  test 'user with dormant login from different ip' do
    user = create(:user_with_dormant_login_from_different_ip)
    assert_equal(user.dormant_account?, true)
  end

  test 'user with suspicious login for same ip' do
    user = create(:user_with_suspicious_login)
    assert_equal(user.suspicious?, true)
  end
end
require_relative 'test_helper.rb'


class SuspiciousLoginIntegrationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @@default_ip = '127.0.0.4'
    @request = ActionDispatch::Request.new({})
  end

  test 'new user' do
    user = create(:new_user)
    assert_equal(user.suspicious?(@request), false)
  end

  test 'user with honest login' do
    user = create(:user_with_honest_login)
    assert_equal(user.suspicious?(@request), false)
  end

  test 'user with dormant login from existing previous ip' do
    @@default_ip = '127.0.0.1'
    user = create(:user_with_dormant_login)
    assert_equal(user.dormant_account?(@request), false)
  end

  test 'user with dormant login from different ip' do
    @request.remote_ip = '227.0.0.1'
    user = create(:user_with_dormant_login)
    assert_equal(user.dormant_account?(@request), true)
  end

  test 'user with suspicious login from existing ip' do
    user = create(:user_with_suspicious_login)
    assert_equal(user.suspicious?(@request), true)
  end
end
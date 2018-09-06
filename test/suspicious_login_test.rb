require_relative 'test_helper.rb'

class SuspiciousLoginIntegrationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    password = "qwertyzxcv"

    @user = User.create(id: 2, email: "example_user_02@example.org", password: password, password_confirmation: password, created_at: Time.now, updated_at: Time.now, last_sign_in_at: 1.day.ago)
    @dormant_user = User.create(id: 3, email: "example_user_03@example.org", password: password, password_confirmation: password, created_at: Time.now, updated_at: Time.now, last_sign_in_at: 1.year.ago)
    @external_suspicious_user = User.create(id: 4, email: "suspicious@example.org", password: password, password_confirmation: password, created_at: Time.now, updated_at: Time.now, last_sign_in_at: 1.day.ago)
  end


  test 'normal login' do
    assert_equal(@user.suspicious?, false)
  end

  test 'dormant login' do
    assert_equal(@dormant_user.dormant_account?, true)
  end

  test 'suspicious login devise' do
    assert_equal(@external_suspicious_user.suspicious?, true)
  end
end
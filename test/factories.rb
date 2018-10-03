FactoryBot.define do
  sequence :email do |n|
    "email#{n}@example.com"
  end

  sequence :uid do |n|
    "12345#{n}"
  end

  factory :user, aliases: [:new_user] do
    email
    password        { 'password' }
    created_at      { Time.now.utc }
    updated_at      { Time.now.utc }
    last_sign_in_ip    { '127.0.0.1' }
    current_sign_in_ip { '127.0.0.2' }

    factory :user_with_honest_login do
      last_sign_in_at    { 2.days.ago.utc }
      current_sign_in_at { 1.day.ago.utc }
    end

    factory :user_with_dormant_login do
      last_sign_in_at    { 1.year.ago.utc }
      current_sign_in_at { 6.months.ago.utc }

      factory :user_with_dormant_login_and_recently_sent_login_token do
        login_token_sent_at { Time.now.utc }
        login_token { "TOKEN" }
      end
    end

    factory :user_with_suspicious_login do
      email { 'suspicious@example.org' }

      factory :user_with_suspicious_login_and_recently_sent_login_token do
        login_token_sent_at { Time.now.utc }
        login_token { "TOKEN" }
      end

      factory :user_with_suspicious_login_and_ancient_login_token do
        login_token_sent_at { 1.day.ago.utc }
        login_token { "TOKEN" }
      end
    end
  end
end
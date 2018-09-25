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

    factory :user_with_honest_login do
      last_sign_in_ip    { '127.0.0.1' }
      last_sign_in_at    { 1.day.ago.utc }
    end

    factory :user_with_dormant_login do
      last_sign_in_at    { 1.year.ago.utc }

      factory :user_with_dormant_login_from_same_ip do
        last_sign_in_ip    { '127.0.0.1' }
        current_sign_in_ip { '127.0.0.1' }
      end

      factory :user_with_dormant_login_from_different_ip do
        last_sign_in_ip    { '127.0.0.1' }
        current_sign_in_ip { '127.0.0.3' }

        factory :user_with_dormant_login_from_different_ip_and_recently_sent_login_token do
          login_token_sent_at { Time.now.utc }
          login_token { "TOKEN" }
        end

      end
    end

    factory :user_with_suspicious_login do
      last_sign_in_ip    { '127.0.0.1' }
      current_sign_in_ip { '127.0.0.1' }
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
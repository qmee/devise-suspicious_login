# devise-suspicious_login

A devise extension that helps protect again suspicious logins.

## Getting started

```ruby
gem 'devise-suspicious_login
```

Run `bundle` command to install.

Once installed you need to add `login_token` and `login_token_sent_at` fields to any resources (eg User) that will use need this feature. Below shows how to add this to the `User` model.

```ruby
# For a new migration for the users table, define a migration as follows:
create_table :users do |t|
  t.login_token
end
```

```ruby
# If the table already exists, define a migration and add the following:
change_table :users do |t|
  t.string login_token
  t.datetime :login_token_sent_at
end
```

Add the `:suspicious_login` module to the resource.
This extension requires the resource to have the native devise modules `:trackable` and `:recoverable` attached to it eg:

```ruby
class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :registerable, :authenticatable, :trackable, :suspicious_login
end
```

## Configuration

```ruby
Devise.setup do |config|
  # Period of time to expire token after login_tokens
  # config.expire_login_token_after = 10.minutes

  # Period of time to wait before resending another email for a suspicious login
  # config.resend_login_token_after = 1.minute

  # Period of time after which a user is considered to be dormant and a login treated as suspicious
  # dormant_sign_in_after = 3.months

  # Column to store login token for resource
  # config.token_field_name = :login_token

  # Column to store login token create time for resource
  # config.token_created_at_field_name = :login_token_sent_at

  # Clear token on login (token can only be used once)
  # config.clear_token_on_login = true
end

The generator adds optional configurations to `config/initializers/devise-security.rb`. Enable
the modules you wish to use in the initializer you are ready to add Devise Security modules on top of Devise modules to any of your Devise models:

```ruby
devise :password_expirable, :secure_validatable, :password_archivable, :session_limitable, :expirable
```

## Requirements

* Devise (https://github.com/plataformatec/devise)
* Rails 5.1 onwards (http://github.com/rails/rails)
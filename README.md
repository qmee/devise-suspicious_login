# devise-suspicious_login

A devise extension that helps protect again suspicious logins.

## Getting started

```ruby
gem 'devise-suspicious_login
```

Run `bundle` command to install.


### Quick Installation

Quick Installation should work on most default rails apps.

Run the install generator:

`rails generate suspicious_login:install`

to install the relevant config files `config/initializers/suspicious_login.rb` with default settings.

Next run the ActiveRecord generator for each model you want to enable suspicious_login detection for.

`rails generate active_record:suspicious_login User`

will update and configure the User model automatically. This will also automatically create a database migration that adds the necessary fields to the User model.

Run this migration wih

`rails db:migrate`

By default only dormant users (3 months without a login by default setting) are considered suspicious. Suspicious check for dormant users can be turned of by setting:

```ruby
config.dormant_sign_in after = nil
```

To add a custom suspicious check for a model simply define a method `suspicious_login_attempt?(request)` eg:

```ruby
# request parameter contains the contents of the rails request
def suspicious_login_attempt?(request)
  if request.ip.botnet? return true
  false
end
```


### Manual Installation

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

  # Clear token on login (allows tokens to be one time use only)
  # config.clear_token_on_login = true

  # Skips email initialisation and sending to implement custom logic by overwriting send_suspicious_login_instructions
  # config.skip_suspicious_login_email = true
end
```

Be sure to set all of your devise login failure messages to be the same otherwise an attack will know if the login credentials are correct depending on the failure message returned!

See (test/dummy/config/locales/devise.en.yml)

## Requirements

* Devise (https://github.com/plataformatec/devise)
* Rails 5.1 onwards (http://github.com/rails/rails)
RailsApp::Application.configure do
  config.cache_classes = true
  config.eager_load = false

  config.public_file_server.enabled = true
  config.public_file_server.headers = { 'Cache-Control' => "public, max-age=#{1.hour.seconds.to_i}" }

  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  config.action_dispatch.show_exceptions = false

  config.action_controller.allow_forgery_protection = false
  config.action_mailer.perform_caching = false

  config.action_mailer.delivery_method = :test
  # config.action_mailer.default_url_options = { host: 'test.host' }

  config.active_support.deprecation = :stderr
end

class Devise::Mailer < Devise.parent_mailer.constantize
  include Devise::Mailers::Helpers

  def suspicious_login_instructions(record, unlock_token, opts={})
    @record = record
    @unlock_token = ERB::Util.url_encode(unlock_token)
    devise_mail(record, :suspicious_login_instructions, opts)
  end
end
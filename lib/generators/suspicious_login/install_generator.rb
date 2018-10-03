module SuspiciousLogin
  module Generators
    class InstallGenerator < Rails::Generators::Base

      source_root File.expand_path("../../templates", __FILE__)
      desc "Add SuspiciousLogin config variables and files to rails project"
      def create_initializer
        template('suspicious_login.rb', 'config/initializers/suspicious_login.rb')
      end

      def copy_locale
        copy_file "../../../config/locales/en.yml", "config/locales/suspicious_login.en.yml"
        puts "\n*** IMPORTANT: Be sure to set all devise authentication failure messages to be the same as 'devise.failure.suspicious_login' ***".red
        puts "See https://github.com/ceres629/devise-suspicious_login/blob/master/test/dummy/config/locales/devise.en.yml for an example devise.en.yml.".yellow
      end

      def prepend_application_file
        create_file "config/application.rb", "module Rails\n  class Application < Rails::Application\n  end\nend" if Rails.env.test?
        application "require 'suspicious_login'"
      end
    end
  end
end
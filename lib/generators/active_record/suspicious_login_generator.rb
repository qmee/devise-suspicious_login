require 'generators/active_record/devise_generator'
require 'generators/suspicious_login/orm_helpers'

module ActiveRecord
  module Generators
    class SuspiciousLoginGenerator < ActiveRecord::Generators::Base
      argument :attributes, type: :array, default: [], banner: "field:type field:type"
      include SuspiciousLogin::Generators::OrmHelpers
      source_root File.expand_path("../templates", __FILE__)

      @required_devise_modules = [:trackable, :recoverable]

      def generate_model
        class_path = namespaced? ? class_name.to_s.split("::") : [class_name]

        if behavior == :invoke && !model_exists?
          if Rails.env.test?
            invoke "active_record:model", [name], migration: false
          else
            raise(SuspiciousLogin::MissingModelError, I18n.t('devise.installer.missing_model', name: class_path.last))
          end
        elsif behavior == :revoke
          return
        end
      end

      def copy_devise_migration
        if (behavior == :invoke && model_exists?) || (behavior == :revoke && migration_exists?(table_name))
          migration_template "migration_existing.rb", "#{migration_path}/add_devise_suspicious_login_to_#{table_name}.rb", migration_version: migration_version
        else
          migration_template "migration.rb", "#{migration_path}/devise_create_#{table_name}.rb", migration_version: migration_version
        end
      end

      def add_warden_strategy
        template('../../templates/suspicious_login.rb', 'config/initializers/suspicious_login.rb') unless File.exist?(File.join(destination_root, 'config/initializers/suspicious_login.rb'))

        content = File.read(File.join(destination_root, 'config/initializers/suspicious_login.rb'))

        if content.include?("config.warden do |manager|\n")
          inject_into_file 'config/initializers/suspicious_login.rb', :after => "config.warden do |manager|\n" do
            "    manager.default_strategies(:scope => :#{name.downcase.to_sym}).unshift :suspicious_login_token\n"
          end
        else
          inject_into_file 'config/initializers/suspicious_login.rb', :after => "Devise.setup do |config|" do
            """  config.warden do |manager|
                manager.default_strategies(:scope => :#{name.downcase.to_sym}).unshift :suspicious_login_token
              end
            """
          end
        end
      end

      def migration_data
<<RUBY
t.string #{Devise.token_field_name}
      t.datetime #{Devise.token_created_at_field_name}
RUBY
      end

      def inject_devise_content
        devise_modules_re = /devise((\s*)(:\S*))+/
        suspicious_login_re = /devise(?:(?:\s*)(?::\S*))+(,\s*:suspicious_login)/
        content = File.read(File.join(destination_root, model_path))

        if model_exists?
          class_path = namespaced? ? class_name.to_s.split("::") : [class_name]

          if behavior == :invoke
            devise_content = devise_modules_re.match(content)&.[](0)
            devise_missing_modules = missing_modules(devise_content)
            if devise_content && devise_missing_modules
              updated_devise_content = devise_missing_modules.reduce(devise_content) { |acc, mod| "#{acc}, :#{mod.to_s}" }
              puts I18n.t('devise.installer.missing_modules', missing_modules: devise_missing_modules.join(', '), count: devise_missing_modules.length) if devise_missing_modules.any? && gsub_file(model_path, devise_modules_re, updated_devise_content) > 0
              puts "\n"
            else
              raise(SuspiciousLogin::DeviseMissingFromModel, I18n.t('devise.installer.devise_missing', name: class_path.last)) if !Rails.env.test?
            end
          elsif behavior == :revoke
            chop_content = suspicious_login_re.match(content)&.[](1)
            force_gsub_file(model_path, chop_content, "") if chop_content
          end
        end
      end

      def rails5?
        Rails.version.start_with? '5'
      end

      def migration_version
        if rails5?
          "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
        end
      end
    end
  end
end

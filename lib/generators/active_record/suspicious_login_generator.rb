require 'generators/active_record/devise_generator'
require 'generators/suspicious_login/orm_helpers'

module ActiveRecord
  module Generators
    class SuspiciousLoginGenerator < ActiveRecord::Generators::Base
      argument :attributes, type: :array, default: [], banner: "field:type field:type"
      include SuspiciousLogin::Generators::OrmHelpers
      source_root File.expand_path("../templates", __FILE__)

      def copy_devise_migration
        if (behavior == :invoke && model_exists?) || (behavior == :revoke && migration_exists?(table_name))
          migration_template "migration_existing.rb", "#{migration_path}/add_devise_suspicious_login_to_#{table_name}.rb", migration_version: migration_version
        else
          migration_template "migration.rb", "#{migration_path}/devise_create_#{table_name}.rb", migration_version: migration_version
        end
      end

      def generate_model
        invoke "active_record:model", [name], migration: false unless model_exists? && behavior == :invoke
      end

      def migration_data
<<RUBY
t.string #{Devise.token_field_name}
      t.datetime #{Devise.token_created_at_field_name}
RUBY
      end

      def inject_devise_content
        re = /devise((\s*)(:\S*))+/

        if model_exists?
          content = File.read(File.join(destination_root, model_path))
          devise_content = re.match(content)&.[](0)
          if devise_content && !devise_content.include?(":suspicious_login")
            new_devise_content = append_devise_module(devise_content)
            gsub_file(model_path, re, new_devise_content)
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

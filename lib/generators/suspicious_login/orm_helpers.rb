module SuspiciousLogin
  module Generators
    module OrmHelpers
      def force_gsub_file(path, flag, *args, &block)
        config = args.last.is_a?(Hash) ? args.pop : {}

        path = File.expand_path(path, destination_root)
        say_status :gsub, relative_to_original_destination_root(path), config.fetch(:verbose, true)

        unless options[:pretend]
          content = File.binread(path)
          content.gsub!(flag, *args, &block)
          File.open(path, "wb") { |file| file.write(content) }
        end
      end

      def required_devise_modules
        [:trackable, :recoverable, :suspicious_login]
      end

      def missing_modules(devise_content)
        missing_modules = []
        required_devise_modules.each { |mod| missing_modules << mod unless devise_content&.include?(mod.to_s)}
        missing_modules
      end

      def devise_module_exists?(devise_content, module_name)
        devise_content.include?(module_name)
      end

      def append_devise_module(devise_content, module_name)
       (devise_content.blank? || devise_content.include?(module_name.to_s)) ? devise_content : devise_content + ", :#{module_name.to_s}"
      end

      def model_exists?
        File.exist?(File.join(destination_root, model_path))
      end

      def migration_exists?(table_name)
        Dir.glob("#{File.join(destination_root, migration_path)}/[0-9]*_*.rb").grep(/\d+_add_devise_suspicious_login_to_#{table_name}.rb$/).first
      end

      def migration_path
        if Rails.version >= '5.0.3'
          db_migrate_path
        else
          @migration_path ||= File.join("db", "migrate")
        end
      end

      def model_path
        @model_path ||= File.join("app", "models", "#{file_path}.rb")
      end
    end
  end
end
require_relative '../test_helper.rb'

if DEVISE_ORM == :active_record
  require 'generators/active_record/suspicious_login_generator'

  class ActiveRecordGeneratorTest < Rails::Generators::TestCase
    tests ActiveRecord::Generators::SuspiciousLoginGenerator
    destination File.expand_path('../../tmp', __FILE__)
    setup :prepare_destination

    test "all files created with correct syntax" do
      run_generator %w(foo)
      assert_migration "db/migrate/devise_create_foos.rb", /def change/
    end

    test "update model migration when model exists" do
      run_generator %w(foo)
      assert_file "app/models/foo.rb"
      run_generator %w(foo)
      assert_migration "db/migrate/add_devise_suspicious_login_to_foos.rb", /#{Devise.token_field_name}/
    end

    test "all files are deleted" do
      run_generator %w(foo)
      run_generator %w(foo)
      assert_migration "db/migrate/devise_create_foos.rb"
      assert_migration "db/migrate/add_devise_suspicious_login_to_foos.rb"
      run_generator %w(foo), behavior: :revoke
      assert_no_migration "db/migrate/add_devise_suspicious_login_to_foos.rb"
      assert_migration "db/migrate/devise_create_foos.rb"
      run_generator %w(foo), behavior: :revoke
      assert_no_migration "db/migrate/devise_create_foos.rb"
      assert_no_file "app/models/foo.rb"
    end
  end
end
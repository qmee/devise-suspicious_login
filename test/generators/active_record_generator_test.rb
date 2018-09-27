require_relative '../test_helper.rb'

if DEVISE_ORM == :active_record
  require 'generators/active_record/suspicious_login_generator'

  class ActiveRecordGeneratorTest < Rails::Generators::TestCase
    tests ActiveRecord::Generators::SuspiciousLoginGenerator
    destination File.expand_path('../../tmp', __FILE__)
    setup :prepare_destination

    test "update model migration when model exists in test mode" do
      run_generator %w(foo)
      assert_file "app/models/foo.rb"
      run_generator %w(foo)
      assert_migration "db/migrate/add_devise_suspicious_login_to_foos.rb", /#{Devise.token_field_name}/
    end

    test "raise error if model is not present when not in test mode" do
      Rails.env = 'prod'
      assert_raise SuspiciousLogin::MissingModelError do
        run_generator %w(foo)
      end
      Rails.env = 'test'
      assert_no_file "app/models/foo.rb"
    end

    test "all files are deleted except the model" do
      run_generator %w(foo)
      run_generator %w(foo)
      assert_migration "db/migrate/add_devise_suspicious_login_to_foos.rb"
      run_generator %w(foo), behavior: :revoke
      assert_no_migration "db/migrate/add_devise_suspicious_login_to_foos.rb"
    end
  end
end
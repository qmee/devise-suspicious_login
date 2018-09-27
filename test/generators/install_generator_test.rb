require_relative '../test_helper.rb'
require 'generators/suspicious_login/install_generator'

class InstallGeneratorTest < Rails::Generators::TestCase
  tests SuspiciousLogin::Generators::InstallGenerator
  destination File.expand_path("../../tmp", __FILE__)
  setup :prepare_destination

  test "assert all files created" do
    run_generator
    assert_file "config/initializers/suspicious_login.rb", /SuspiciousLogin Extension/
    assert_file "config/locales/suspicious_login.en.yml", /missing_modules:/
    assert_file "config/application.rb", /require 'suspicious_login'/
  end
end
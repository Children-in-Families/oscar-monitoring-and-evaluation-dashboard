ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails_helper'
require 'shoulda/matchers'
require 'ffaker'
require 'factory_bot_rails'
require 'capybara/rails'
require 'database_cleaner'
require 'capybara/poltergeist'
require 'pundit/rspec'
Dir[Rails.root.join('spec/supports/**/*.rb')].each { |f| require f }

Capybara.default_driver = :poltergeist
Capybara.javascript_driver = :poltergeist
# Capybara.app_host= 'http://lvh.me'

Capybara.register_server :thin do |app, port, host|
  require 'rack/handler/thin'
  Rack::Handler::Thin.run(app, :Port => port, :Host => host)
end

Capybara.server = :thin

Capybara.register_driver :poltergeist do |app|
  options = {
    js_errors: false,
    phantomjs_options: ['--load-images=true', '--ignore-ssl-errors=yes', '--ssl-protocol=any'],
    timeout: 60
  }
  Capybara::Poltergeist::Driver.new(app, options)
end


RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = [:should, :expect] }
  config.include Warden::Test::Helpers
  config.include FactoryBot::Syntax::Methods
  config.include DeviseTokenAuthHelpers, type: :request
  config.include ApplicationHelper

  config.before(type: :feature) do
    allow_any_instance_of(Browser::Generic).to receive(:modern?) { true }
  end

  config.before(type: :request) do
    allow_any_instance_of(Browser::Generic).to receive(:modern?) { true }
  end

  config.before(:each, type: :feature) do
    default_url_options[:locale] = I18n.default_locale
    driver_shares_db_connection_with_specs = Capybara.current_driver == :poltergeist
    DatabaseCleaner.strategy = :truncation unless driver_shares_db_connection_with_specs
  end

  config.before(:suite) do
    # Clean all tables to start
    DatabaseCleaner.clean_with :truncation
    # Use transactions for tests
    DatabaseCleaner.strategy = :transaction
    # Truncating doesn't drop schemas, ensure we're clean here, app *may not* exist
    Apartment::Tenant.drop('app') rescue nil
    # Create the default tenant for our tests
    Donor.create_and_build_tanent(name: 'Donor Testing', schema_name: 'app')
    Donor.last.logo.attach(io: File.open(Rails.root.join('app/assets/images/sci_logo.png')), filename: 'sci_logo.png')
  end

  config.before(:each) do
    Apartment::Tenant.switch! 'app'
  end

  config.before(:each, js: true) do
    page.driver.browser.url_blacklist = %w(http://use.typekit.net https://fonts.gstatic.com https://fonts.googleapis.com http://cdn.rawgit.com)
    page.driver.browser.url_whitelist = %w(http://app.lvh.me http://lvh.me 127.0.0.1)
    Capybara.default_max_wait_time = 10
    Capybara.always_include_port = true

    Apartment::Tenant.switch! 'app'
    sub_domain = Donor.current ? Donor.current.schema_name : 'app'
    Capybara.app_host = "http://#{sub_domain}.lvh.me"
  end

  config.after(:each) do
    Apartment::Tenant.reset
    DatabaseCleaner.clean
    CleanTestDatabase.clean('public', 'app')
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.after(:each) do
    if Rails.env.test? || Rails.env.cucumber?
      FileUtils.rm_rf(Dir["#{Rails.root}/spec/support/uploads"])
    end
    DatabaseCleaner.clean
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.shared_context_metadata_behavior = :apply_to_host_groups

end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end


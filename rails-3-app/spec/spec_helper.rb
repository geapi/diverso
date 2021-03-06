# The simplecov commands belong at the top per instructions
#require 'simplecov'
#SimpleCov.start 'rails'

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'shoulda'

FileUtils.mkdir_p(Reports::Base::CSV_PATH)

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|

  config.include ObjectCreationMethods
  config.mock_with :rspec

  config.global_fixtures = :all

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.before(js: nil) do
    config.use_transactional_fixtures = true
  end

end

# should not be necessary if database cleaner is active
ActiveRecord::ConnectionAdapters::ConnectionPool.class_eval do
  def current_connection_id
    Thread.main.object_id
  end
end

Resque.inline = true
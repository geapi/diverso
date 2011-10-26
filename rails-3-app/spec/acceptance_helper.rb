require 'spec_helper'
require 'capybara/rspec'
require 'capybara/rails'

# supress abundant log messages
$VERBOSE = nil

def confirm_all
  page.execute_script(%Q{$('.confirmation input[type=checkbox]').attr('checked', 'checked').click()})
end

require 'database_cleaner'
require 'headless'

headless = Headless.new
headless.start

at_exit do
  unless ENV['RUNNING_CI']
    headless.destroy
  end
end

def build_fixtures
  Fixtures.reset_cache
  fixtures_folder = File.join(Rails.root.to_s, 'spec', 'fixtures')
  fixtures = Dir[File.join(fixtures_folder, '*.yml')].map { |f| File.basename(f, '.yml') }
  DatabaseCleaner.clean
  Fixtures.create_fixtures(fixtures_folder, fixtures)
end

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation, {:except => %w[ ]}
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(js: true) do
    config.use_transactional_fixtures = false
    build_fixtures()
    DatabaseCleaner.start
  end

  config.after(:each, js: true) do
    config.use_transactional_fixtures = true
    build_fixtures()
  end
end
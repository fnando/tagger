ENV["RAILS_ENV"] = "test"
require "rails"
require "tagger"
require File.dirname(__FILE__) + "/support/config/boot"
require "rspec/rails"

require "support/models"

# Load database schema
load File.dirname(__FILE__) + "/schema.rb"

RSpec.configure do |config|
  config.mock_with :rspec
  config.fixture_path = File.dirname(__FILE__) + "/fixtures"
  config.use_transactional_fixtures = true
end

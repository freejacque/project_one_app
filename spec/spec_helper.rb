ENV['RACK_ENV'] = 'test' #sets the rack environment for testing

require 'rspec'
require 'capybara/rspec'
require './app'

Capybara.app = App

RSpec.configure do |config|
  config.include Capybara::DSL
end

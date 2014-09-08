source "https://rubygems.org"

ruby "2.1.2"

gem 'sinatra', '1.4.5'
gem 'redis',  '3.1.0'
gem 'httparty'
gem 'awesome_print', '1.2.0'
gem 'json'
gem 'selenium-webdriver', '~> 2.42.0'

# only used in development locally
group :development do
  gem 'pry'
  gem 'shotgun'
end

group :production do
  # gems specific just in the production environment
end

group :test do
  gem 'rspec', '~> 3.0.0'
  gem 'capybara', '~> 2.4.1'
end

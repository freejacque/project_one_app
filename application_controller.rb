require './helpers/redis_helper'
require './helpers/app_methods'

class ApplicationController < Sinatra::Base

  helpers RedisHelper
  helpers AppMethods


  configure do
    enable :logging
    enable :method_override
    enable :sessions
    set :session_secret, 'whateverman'
    uri = URI.parse(ENV["REDISTOGO_URL"])
    $redis = Redis.new({:host => uri.host,
                        :port => uri.port,
                        :password => uri.password,
                        :db => 1}) # redis databases can go from 0 to 14
  end

  before do
    logger.info "Request Headers: #{headers}"
    logger.warn "Params: #{params}"
  end

  after do
    logger.info "Response Headers: #{response.headers}"
  end
  ########################
  # API Keys
  ########################
  CLIENT_ID     = ENV["CRITIQUE_IT_GOOGLE_CLIENT_ID"]
  CLIENT_SECRET = ENV["CRITIQUE_IT_GOOGLE_CLIENT_SECRET"]
  EMAIL_ADDRESS = ENV["CRITIQUE_IT_GOOGLE_EMAIL_ADDRESS"]
  if ENV["RACK_ENV"] == "development"
    CALLBACK_URL  = ENV["CRITIQUE_IT_CALLBACK_URL_DEV"]
  else
    CALLBACK_URL = ENV["CRITIQUE_IT_CALLBACK_URL"]
  end

end

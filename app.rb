require 'sinatra/base'


class App < Sinatra::Base

  ########################
  # Configuration
  ########################

  configure do
    enable :logging
    enable :method_override
    enable :sessions
  end

  before do
    logger.info "Request Headers: #{headers}"
    logger.warn "Params: #{params}"
  end

  after do
    logger.info "Response Headers: #{response.headers}"
  end

  ########################
  # Routes
  ########################

  get('/') do

    render(:erb, :index)
  end

  get('/password_error') do
    render(:erb, :password_error)
  end

  get('/sign_up') do
    render(:erb, :sign_up)
  end
end

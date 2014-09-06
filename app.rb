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
    if "user_password" == "password"
    redirect('/home')
    else
      redirect('/password_error')
    render(:erb, :index)
  end

  get('/password_error') do

  end
end

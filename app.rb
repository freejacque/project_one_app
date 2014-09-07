require 'sinatra/base'
require 'httparty'
require 'pry'


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
  # API Keys
  ########################
  CLIENT_ID     = "594095716528-a8lib8gqpnp6o00k23n58c01ev8r5b3d.apps.googleusercontent.com"
  CLIENT_SECRET = "pQ_Xf9VbZPEcN_wQ5pgNo9X1"
  EMAIL_ADDRESS = "594095716528-a8lib8gqpnp6o00k23n58c01ev8r5b3d@developer.gserviceaccount.com"
  CALLBACK_URL  = "http://127.0.0.1:9393/oauth_callback"

  ########################
  # Routes
  ########################

  get('/') do
    if "google_account"
      base_url        = "https://accounts.google.com/o/oauth2/auth"
      response_type   = "code"
      scope           = "email_profile".gsub('_','%20')
      code            = params[:code]
      state           = SecureRandom.urlsafe_base64
      session[:state] = state
      @url            = "#{base_url}?response_type=#{response_type}&scope=#{scope}&state=#{state}&redirect_uri=#{CALLBACK_URL}&client_id=#{CLIENT_ID}&approval_prompt=auto"
    end
      render(:erb, :index)
  end

  post('/') do
    # if

    # else
      if params[:user_password] == "password"
          redirect('/home')
      else
          redirect('/password_error')
      end
      render(:erb, :index)
    # end
  end

  get('/oauth_callback') do
    code  = params[:code]
    #send a post
    # if params[:state] == session[:state]
      #send a post
    response = HTTParty.post("https://accounts.google.com/o/oauth2/token",
                :body => {
                code: code,
                client_id: CLIENT_ID,
                client_secret: CLIENT_SECRET,
                redirect_uri: CALLBACK_URL,
                grant_type: "authorization_code",
                },
                :headers => {
                  "Content-Type" => "application/x-www-form-urlencoded",
                  "Accept" => "application/json",
                })
      session[:access_token] = response[:access_token]
    # end
    redirect to('/home')
  end

  get('/password_error') do
    render(:erb, :password_error)
  end

  get('/sign_up') do
    render(:erb, :sign_up)
  end

  get('/home') do
    render(:erb, :home)
  end

end

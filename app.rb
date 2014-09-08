require 'sinatra/base'
require 'httparty'
require 'pry'
require 'redis'
require 'json'
require 'uri'


class App < Sinatra::Base

  ########################
  # Configuration
  ########################

  configure do
    enable :logging
    enable :method_override
    enable :sessions
    uri = URI.parse(ENV["REDISTOGO_URL"])
    $redis = Redis.new({:host => uri.host,
                        :port => uri.port,
                        :password => uri.password})
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
    # if
      base_url        = "https://accounts.google.com/o/oauth2/auth"
      response_type   = "code"
      scope           = "email_profile".gsub('_','%20')
      state           = SecureRandom.urlsafe_base64
      session[:state] = state
      @url            = "#{base_url}?response_type=#{response_type}&scope=#{scope}&state=#{state}&redirect_uri=#{CALLBACK_URL}&client_id=#{CLIENT_ID}&approval_prompt=auto"
    # end
    # binding.pry
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
    # binding.pry
    if  session[:state] == params[:state]
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
    end
    redirect to('/home')
  end

  get('/password_error') do
    render(:erb, :password_error)
  end

  get('/sign_up') do
    render(:erb, :sign_up)
  end

  # post('/sign_up') do
  #   $redis.set("user:0", {
  #                         user: "me",
  #                         email: "email@me.com",
  #                         password: "password",
  #                         profile_pic: "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",
  #                         })
  #   index = $redis.incr("user:index")
  #   new_user = {
  #     # index: index,
  #     user: params[:user_id],
  #     email: params[:user_email],
  #     password: params[:user_password],
  #     profile_pic: params[:profile_pic_url],
  #   }
  #   binding.pry
  #   @user = new_user[:user_id]
  #   @password = new_user[:user_password]
  #   $redis.set("user:#{index}", new_user.to_json)
  #   redirect to('/sign_up')
  # end

  get('/home') do
    render(:erb, :home)
  end

end

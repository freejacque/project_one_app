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
    set :session_secret, "whateverman"
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
      base_url        = "https://accounts.google.com/o/oauth2/auth"
      response_type   = "code"
      scope           = "openid email profile".gsub(' ','%20')
      state           = SecureRandom.urlsafe_base64
      session[:state] = state
      @url            = "#{base_url}?response_type=#{response_type}&scope=#{scope}&state=#{state}&redirect_uri=#{CALLBACK_URL}&client_id=#{CLIENT_ID}&approval_prompt=auto"
      render(:erb, :index)
  end

  # post('/') do
  #   # if

  #   # else
  #     if params[:user_password] == "password"
  #         redirect('/home')
  #     else
  #         redirect('/password_error')
  #     end
  #     render(:erb, :index)
  #   # end
  # end

  get('/oauth_callback') do
    code  = params[:code]
    #send a post
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
      session[:access_token] = response["access_token"]
      redirect to('/home')
    else
      redirect('password_error')
    end
  end

  get('/password_error') do
    render(:erb, :password_error)
  end

  # get('/sign_up/') do
  #   if params[:sent] == "true"
  #     @sign_up_success_message = true
  #   end
  #   render(:erb, :sign_up)
  # end

  # get('/sign_up') do
  #     render(:erb, :sign_up)
  # end

  # post('/sign_up') do
  #   # $redis.flushdb
  #   index = $redis.incr("user:index")
  #   new_user = {
  #     # index: index,
  #     user: params[:user_id],
  #     email: params[:user_email],
  #     password: params[:user_password],
  #     profile_pic: params[:profile_pic_url],
  #   }
  #   @user = params[:user_id]
  #   @password = params[:user_password]
  #   $redis.set("#{@user}_posts", [].to_json)
  #   $redis.set("user:#{index}", new_user.to_json)
  #   redirect to('/sign_up/?sent=true')
  # end

  get('/home') do
    redis_index = $redis.incr("user:index")
    url = "https://www.googleapis.com/plus/v1/people/me"
    response = HTTParty.get(url, {
                        :headers => { "Authorization" => "Bearer #{session[:access_token]}"
                      }})
    session[:user_information] = response
    user = session[:user_information]["id"]
    $redis.set("#{user}_posts", [].to_json)
    $redis.set("#{redis_index}", "#{user}" )
    binding.pry
    render(:erb, :home)
  end

  get('/posts/new') do
    render(:erb, :new_post_form)
  end

  post('/posts') do
    @user = session[:user_information]["id"]
    binding.pry
    new_post = {
      title: params[:img_title],
      category: params[:img_category],
      url: params[:img_url],
      description: params[:description],
    }
    posts = JSON.parse($redis.get("#{@user}_posts"))
    posts.push(new_post)
    $redis.set("#{@user}_posts", posts.to_json )
    # binding.pry
    redirect to("/feed/#{@user}")
  end

  get('/feed/:user') do
    user = params[:user]
    @feed_posts = JSON.parse($redis.get("#{user}_posts"))
    render(:erb, :feed)
  end
end

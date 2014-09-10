require 'sinatra/base'
require 'httparty'
require 'pry' if ENV["RACK_ENV"] == "development"
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
    # use Rack::Session::Cookie, :key => 'rack.session',
    #                            :path => '/',
    #                            :secret => 'whateverman'
    set :session_secret, 'whateverman'
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
  # $redis.setnx("users", [].to_json)
  ########################
  # Routes
  ########################

  get('/') do
      base_url        = "https://accounts.google.com/o/oauth2/auth"
      response_type   = "code"
      scope           = "openid email profile".gsub(' ','%20')
      state           = SecureRandom.urlsafe_base64
      session[:state] = state
      @url            = "#{base_url}?response_type=#{response_type}" +
                        "&scope=#{scope}&state=#{state}" +
                        "&redirect_uri=#{CALLBACK_URL}" +
                        "&client_id=#{CLIENT_ID}" +
                        "&approval_prompt=auto"
      render(:erb, :index)
  end

  get('/oauth_callback') do
    code  = params[:code]
    puts session[:marp]
    #send a post
    # if  session[:state] == params[:state]
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
    # end
      redirect to('/home')
    # else
      # redirect('password_error')
    # end
  end

  get('/logout') do
    session[:access_token] = nil
    redirect to('/')
  end

  get('/password_error') do
    render(:erb, :password_error, :layout)
  end

  get('/home/:id') do
    @user = params[:id]
    render(:erb, :home)
  end

  get('/home') do
    url = "https://www.googleapis.com/plus/v1/people/me"
    response = HTTParty.get(url, {
                        :headers => { "Authorization" => "Bearer #{session[:access_token]}"
                      }})
    puts session[:marp]
    @user_information = response
    user = @user_information["id"]
    $redis.setnx("#{@user}_posts", [].to_json)
    users = JSON.parse($redis.get("users"))
    users.push(user)
    $redis.set("users", users.to_json)
    redirect("/home/#{user}")
  end


  get('/posts/new') do
    render(:erb, :new_post_form)
  end

  post('/posts') do
    @user = params[:user_id]
    new_post = {
      title: params[:img_title],
      category: params[:img_category],
      url: params[:img_url],
      description: params[:description],
    }
    posts = JSON.parse($redis.get("#{@user}_posts"))
    posts.push(new_post)
    $redis.set("#{@user}_posts", posts.to_json )
    redirect to("/feed/#{@user}")
  end

  get('/feed/:user') do
    @user = params[:user]
    @feed_posts = JSON.parse($redis.get("#{@user}_posts"))
    render(:erb, :feed)
  end

  get('/posts/:user') do
    @user = params[:user]
    @posts = JSON.parse($redis.get("#{@user}_posts"))
    render(:erb, :posts)
  end

  get('/each_post/:id') do
    @id = params[:id]
    index = params[:id].to_s[-1].to_i
    user = params[:id].to_s.slice(0..-2)
    @posts = JSON.parse($redis.get("#{user}_posts"))
    @selected_post = @posts.reverse[index]
    render(:erb, :each_post)
  end

  delete('/each_post/:id') do
    @id = params[:id]
    index = params[:id].to_s[-1].to_i
    user = params[:id].to_s.slice(0..-2)
    @posts = JSON.parse($redis.get("#{user}_posts"))
    post_to_delete = @posts.reverse[index]
    @posts.delete(post_to_delete)
    $redis.set("#{user}_posts", @posts.to_json)
    redirect to("/posts/#{user}")
  end

  get('/edit_post/:id') do
    @id = params[:id]
    index = params[:id].to_s[-1].to_i
    user = params[:id].to_s.slice(0..-2)
    @posts = JSON.parse($redis.get("#{user}_posts"))
    @post_to_edit = @posts.reverse[index]
    render(:erb, :edit_post_form)
  end

  put('/edit_post/:id') do
    @id = params[:id]
    index = params[:id].to_s[-1].to_i
    user = params[:id].to_s.slice(0..-2)
    @posts = JSON.parse($redis.get("#{user}_posts"))
    @post_to_edit = @posts.reverse[index]
    @post_to_edit["title"] = params["img_title"]
    @post_to_edit["category"] = params["img_category"]
    @post_to_edit["url"] = params["img_url"]
    @post_to_edit["description"] = params["img_description"]
    @posts.reverse[index] = @post_to_edit
    $redis.set("#{user}_posts", @posts.to_json)
    redirect to("/posts/#{user}")
  end

end

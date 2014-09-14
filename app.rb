require './application_controller'


class App < ApplicationController

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
    code = params[:code]
    puts session[:marp]
    # FIXME
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
    render(:erb, :"signin/password_error")
  end

  get('/home/:id') do
    @user = params[:id]
    render(:erb, :home)
  end

  get('/home') do
    url = "https://www.googleapis.com/plus/v1/people/me"
    response = HTTParty.get(url,
                {:headers => {
                    "Authorization" => "Bearer #{session[:access_token]}"
                             }
                })
    puts session[:marp]
    @user_information = response
    user = @user_information["id"]
    $redis.setnx("#{@user}_posts", [].to_json)
    users = redis_get("users")
    users.push(user)
    redis_set("users", users)
    redirect("/home/#{user}")
  end


  get('/posts/new') do
    render(:erb, :"posts/new")
  end

  post('/posts') do
    @user = params[:user_id]
    new_post = {
                title: params[:img_title],
                category: params[:img_category],
                url: params[:img_url],
                description: params[:description],
               }
    posts = redis_get("#{@user}_posts")
    posts.push(new_post)
    redis_set("#{@user}_posts", posts)
    redirect to("/feed/#{@user}")
  end

  get('/feed/:user') do
    @user = params[:user]
    @feed_posts = redis_get("#{@user}_posts")
    render(:erb, :"feed/index")
  end

  get('/posts/:user') do
    @user = params[:user]
    @posts = redis_get("#{@user}_posts")
    render(:erb, :"posts/index")
  end

  get('/each_post/:id') do
    @id = params[:id]
    params_parser(@id)
    @selected_post = @posts.reverse[@index]
    render(:erb, :"posts/show")
  end

  delete('/each_post/:id') do
    @id = params[:id]
    params_parser(@id)
    post_to_delete = @posts.reverse[@index]
    @posts.delete(post_to_delete)
    redis_set("#{@user}_posts", @posts)
    redirect to("/posts/#{@user}")
  end

  get('/edit_post/:id') do
    @id = params[:id]
    params_parser(@id)
    @post_to_edit = @posts.reverse[@index]
    render(:erb, :"posts/edit")
  end

  put('/edit_post/:id') do
    @id = params[:id]
    params_parser(@id)
    @post_to_edit = @posts.reverse[@index]
    @post_to_edit["title"]       = params["img_title"]
    @post_to_edit["category"]    = params["img_category"]
    @post_to_edit["url"]         = params["img_url"]
    @post_to_edit["description"] = params["img_description"]
    @posts.reverse[@index]        = @post_to_edit
    $redis.set("#{@user}_posts", @posts)
    redirect to("/posts/#{@user}")
  end

end

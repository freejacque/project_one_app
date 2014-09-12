module AppMethods

  def params_parser(id)
    @index = params[:id].to_s.slice(21..22).to_i
    @user  = params[:id].to_s.slice(0..20)
    @posts = redis_get("#{@user}_posts")
  end

end

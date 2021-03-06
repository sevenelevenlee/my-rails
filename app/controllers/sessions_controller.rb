class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def new
    flash[:failer_provider] = request.env['omniauth.error.strategy'].name
    flash[:failer_type] = request.env['omniauth.error.type']
  end

  def create
    #自己验证用户
    # @user = User.authentication(params[:login], params[:password])
    # if @user
    #   session[:user_id] = @user.id
    #   flash[:notice] = "Welcome #{@user.login}"
    #   redirect_to posts_path
    # else
    #   flash[:notice] = "The Login or Password is invalid"
    #   redirect_to new_session_path
    # end
    user = User.from_auth(request.env['omniauth.auth'])
    session[:user_id] = user.id
    flash[:notice] = "Welcome #{user.nickname}"
    redirect_to posts_path
  end
end

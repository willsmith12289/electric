class SessionsController < ApplicationController
  before_action :set_cart, only: :new
  skip_before_action :authenticate_user!
  def new
  end

  def create
    user = current_user
    if user and user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to admin_url
    else
      redirect_to login_url, alert: "Invalid User/Password combo"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to blog_path, notice: "Logged Out"
  end
end
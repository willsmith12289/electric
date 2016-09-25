class SessionsController < ApplicationController
  before_action :set_cart, only: :new
  skip_before_action :authorize
  def new
  end

  def create
    user = User.find_by(name: params[:name])
    if user and user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to admin_url
    else
      redirect_to login_url, alert: "Invalid User/Password combo"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to store_url, notice: "Logged Out"
  end
end
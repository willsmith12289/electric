class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_cart
  
  def search
    if params[:home_depot]
      @hd_products = nokogiri_search
      render "index", locales: {hd_products: @hd_products}
    else
      @products = Product.search(params[:q]).order("created_at DESC")
      render "index"
    end
  end

  protected

    # def authorize
    #   unless User.find_by(id: session[:user_id])
    #     redirect_to login_url, notice: "Please Log In"
    #   end
    # end
  private

    def set_cart 
        @cart = Cart.find(session[:cart_id])
      rescue ActiveRecord::RecordNotFound
        @cart = Cart.create
        session[:cart_id] = @cart.id
    end
end

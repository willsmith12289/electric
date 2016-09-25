class AdminController < ApplicationController
  before_action :set_cart
  def index
    @carts = Cart.all
    @total_sales = 1000
  end
end

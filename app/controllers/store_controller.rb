class StoreController < ApplicationController
  before_action :set_cart
  skip_before_action :authenticate_user!
  def index
    @products = Product.order_by(DESC)
  end
end

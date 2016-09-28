class StoreController < ApplicationController
  before_action :set_cart
  skip_before_action :authorize
  def index
    @products = Product.order_by(DESC)
  end
end

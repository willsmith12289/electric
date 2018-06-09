class AdminController < ApplicationController
  before_action :set_cart
  def index
    @carts = Cart.all
    total = []
    @carts.each do |c|
      c.line_items.each do |l|
        total<<l.total_price.to_f
      end
    end
    @total_sales = total.sum
  end
end

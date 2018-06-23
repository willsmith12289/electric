class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :set_cart
  before_action :searching?
  before_action :user_is_client?

  def index
    @products = Product.all
  end

  def show
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to products_path, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def product_params
      params.require(:product).permit(:title, :description, :price, :image)
    end

    def searching?
      if params.has_key?(:q)
        @products = Product.search_products(params[:q]).order("created_at DESC")
        render "index"
      end
    end

    def set_product
      @product = Product.find(params[:id])
    end

    def user_is_client?
      unless current_user.try(:client) || current_user.try(:admin)
        redirect_to two_barn_farm_path
      end
    end
end

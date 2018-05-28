class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :set_cart
  require 'open-uri'
  # GET /products
  # GET /products.json
  def index
    @products = Product.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
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

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
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

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def search
    # puts '###########'
    # puts '###########'
    # puts '###########'
    # puts '###########'
    # puts '###########'
    # puts '###########'
    # puts '###########'
    if params[:home_depot]
      @hd_products = nokogiri_search
      render "index", locales: {hd_products: @hd_products}
    else
      @products = Product.search(params[:q]).order("created_at DESC")
      render "index"
    end
  end
  private

    def nokogiri_search
      doc = Nokogiri::HTML(open("https://www.homedepot.com/s/'#{params[:q].downcase.split.join('-')}'?NCNI-5")) do |config|
        config.strict.noblanks
      end
      images = build_image(doc.css('div.js-pod img'))
      titles = build_title(doc.css('div.plp-pod__info .pod-plp__description'))
      descriptions = build_description(
        doc.css('div.plp-pod__info .pod-plp__description a'))
      prices = build_price(
        doc.css('div.plp-pod__info .price__wrapper .price'),
        doc.css('div.plp-pod__info .price__wrapper .price .price__format[2]'))

      return build_products(titles, prices, descriptions, images)
    end

    def build_products(titles, prices, descriptions, images)
      hd_products = Array.new()
      titles.count.times do |x|
      product = {title: titles[x], price: prices[x], description: descriptions[x], image_url: images[x]}
        hd_products<<product
      end
      return hd_products
    end

    def build_description(item_descriptions)
      descripts = Array.new()
      item_descriptions.each{|id| descripts<<id['href']}
      return descripts
    end

    def build_image(item_images)
      imgs = Array.new()
      item_images.each{|i| imgs<<i['src'].strip}
      return imgs
    end

    def build_title(item_titles)
      titles = Array.new
      item_titles.each{|t| titles<<title = t.content.strip.split(' ').drop(1).join(' ').to_s}
      return titles
    end

    def build_price(item_prices, cents)
      prices = Array.new()
      item_prices.each_with_index do |p,i| 
        price = (p.content.include?('/')) ? p.content.split('/')[0].strip : p.content.strip
        price = "#{price.chomp(cents[i].content)}.#{cents[i].content}"
        price.slice!(0)
        prices<<price.to_f
      end
      return prices
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:title, :description, :price, :image_url)
    end
end

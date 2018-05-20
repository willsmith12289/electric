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
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
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
    
    doc = Nokogiri::HTML(open("https://www.homedepot.com/s/'#{params[:q].downcase.split.join('-')}'?NCNI-5")) do |config|
      config.strict.noblanks
    end
    itemImg = doc.css('div.js-pod img')
    itemTitle = doc.css('div.plp-pod__info .pod-plp__description')
    itemDescription = doc.css('div.plp-pod__info .pod-plp__description a')
    itemPrice = doc.css('div.plp-pod__info .price__wrapper .price')
    descripts = Array.new()
    itemDescription.each{|id| descripts<<id['href']}
    imgs = Array.new()
    itemImg.each{|i| imgs<<i['src'].strip}
    titles = Array.new
    itemTitle.each{|t| titles<<title = t.content.strip.split(' ').drop(1).join(' ').to_s}
    prices = Array.new()
    itemPrice.each do |p| 
      prices<<price = (p.content.include?('/')) ? p.content.split('/')[0].strip : p.content.strip
    end
    puts prices
    itemTitle.count.times do |x|
      products = {title: titles[x], price: prices[x], description: descripts[x], image_url: imgs[x]}
      if Product.create(products).valid?
        Product.create(products)
      else
        next
      end
    end
    # imgdesc = imgs.zip(descripts)
    # products = titlePrice.zip(imgdesc)
    # @products = products.each do |p|
    #   p.to_a
    #   prod = Product.new(p['title'], p.image_url, p.description, p.price)
    #   return prod
    # end
    # itemImg.each_with_index do |product, index|
    #   title = itemTitle[index](p.content.strip.start_with? '$') ?
    #   img = itemImg[index]
    #   description = itemDescription[index]
    #   price = itemPrice[index]
    #   # Product.new(,)
    #   puts description
    # end
      # Product.new()
      # img.each{|i| puts i['src']}
      # title.each{|t| puts t.content}
      # price.each{|p| puts p.content}

    # clean_up(itemImg, itemTitle, itemPrice)
    @products = Product.search(params[:q]).order("created_at DESC")
    # @products = Product.all
    render "index"
  end
  private

    def clean_up(img, title, price)
      img.count.times do |product|

      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:title, :description, :price)
    end
end

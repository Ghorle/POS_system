class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]

  # GET /products or /products.json
  def index
    page = params[:page].present? ? params[:page] : 1
    if params[:search].present?
      @products = Product.where("id = ? OR name ILIKE ?", "#{params[:search]}".to_i, "%#{params[:search]}%")
    else
      @products = Product.all
    end
    @products = @products.order(created_at: :desc).page(page).per(10)
  end

  # GET /products/1 or /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
    1.times { @product.ingredients.build }
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to product_url(@product), notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to product_url(@product), notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def products_for_order_creation
    if params[:search].present?
      @products = Product.where("name ILIKE ?", "%#{params[:search]}%").last(10)
    else
      @products = Product.last(10)
    end
  end

  def check_raw_material_availability
    product = Product.find(params[:product_id])
    insufficient_materials = []

    if product.ingredients.present?
      product.ingredients.each do |ingredient|
        raw_material = ingredient.raw_material
        if raw_material.quantity < (ingredient.quantity * params[:qty].to_f).to_f
          insufficient_materials << "Not enough #{raw_material.name} available."
        end
      end
    else
      insufficient_materials << "Raw materials not present for #{product.name}."
    end

    if insufficient_materials.any?
      render json: { success: false, errors: insufficient_materials }, status: :unprocessable_entity
    else
      render json: { success: true, message: "Raw materials are sufficient." }, status: :ok
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:name, :description, :price, product_images: [],
        ingredients_attributes: [:id, :raw_material_id, :quantity,  :_destroy])
    end
end

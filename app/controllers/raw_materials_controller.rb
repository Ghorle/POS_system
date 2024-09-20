class RawMaterialsController < ApplicationController
  before_action :set_raw_material, only: %i[ show edit update destroy ]

  def index
    per_page = 15
    @materials = RawMaterial.order("updated_at desc").page(params[:page]).per(per_page)
    if params[:search].present?
      @materials = @materials.where("id = ? OR name ILIKE ?", "#{params[:search]}".to_i, "%#{params[:search]}%").order("updated_at desc").page(params[:page]).per(per_page)
    end
  end

  # GET /materials/1 or /materials/1.json
  def show
  end

  # GET /materials/new
  def new
    @raw_material = RawMaterial.new
  end

  # GET /materials/1/edit
  def edit
  end

  def create
    @raw_material = RawMaterial.new(raw_material_params)

    respond_to do |format|
      if @raw_material.save
        format.html { redirect_to raw_materials_path, notice: "Inventory added successfully." }
        format.json { render :show, status: :created, location: @raw_material }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @raw_material.errors, status: :unprocessable_entity }
      end
    end
  end

  def import
    if params[:file].present?
      begin
        ImportFile.new(params[:file]).import
        flash[:notice] = "Raw materials imported successfully."
        respond_to do |format|
          format.html { redirect_to raw_materials_path, notice: "Raw materials imported successfully." }
          format.json { render :new, status: :created, location: @raw_material }
        end
      rescue => e
        respond_to do |format|
          format.html { redirect_to raw_materials_path, notice: {error: "Failed to import raw materials: #{e.message}"} }
          format.json { render :new, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to raw_materials_path, notice: {error: "Please upload a file."} }
        format.json { render :new, status: :unprocessable_entity }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_raw_material
    @raw_material = RawMaterial.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def raw_material_params
    params.require(:raw_material).permit(:name, :quantity)
  end
end
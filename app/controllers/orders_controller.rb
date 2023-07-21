class OrdersController < ApplicationController
  before_action :set_order, only: %i[ show edit update destroy products mark_closed mark_ready ]

  # GET /orders or /orders.json
  def index
    @statuses = [["On Going", "on_going"], ["Ready", "ready"], ["Closed", "closed"]]
    @orders = Order.order("updated_at desc").page(params[:page]).per(15)
    if params[:search].present?
      @orders = @orders.where("id = ? OR customer_name ILIKE ? OR customer_contact ILIKE ?", "#{params[:search]}".to_i, "%#{params[:search]}%", "%#{params[:search]}%").order("updated_at desc").page(params[:page]).per(15)
    end
    if params[:sort].present?
      @orders = @orders.where(status: params[:sort]).page(params[:page]).per(15)
    end
  end

  # GET /orders/1 or /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
    1.times { @order.order_products.build }
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
    @order = Order.new(order_params)

    respond_to do |format|
      if @order.employee.blank? && current_user 
        @order.employee = current_user
      end
      if @order.save
        @order.update_order_details
        UserMailer.order_placed(@order).deliver_now
        format.html { redirect_to root_path, notice: "Order was successfully created." }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        @order.update_order_details
        format.html { redirect_to order_url(@order), notice: "Order was successfully updated." }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url, notice: "Order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # GET /orders/1/
  def products
    @order_products = @order.order_products
  end

  # GET /orders/1/
  def mark_closed
    respond_to do |format|
      if @order.update!(status: "closed")
        format.html { redirect_to root_url, notice: "Order Closed." }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /orders/1/
  def mark_ready
    respond_to do |format|
      if @order.update!(status: "ready")
        format.html { redirect_to root_url, notice: "Order Ready." }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def closed
    if params[:search].present?
      @orders = Order.closeds.current_days.where("id = ? OR customer_name ILIKE ?", "#{params[:search]}".to_i, "%#{params[:search]}%")
    else
      @orders = Order.closeds.current_days
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:name, :reference_no, :customer_name, :customer_contact, :gross_total, :tax, :payable_total, :discount, :order_type,
        order_products_attributes: [:id, :product_id, :qty,  :_destroy])
    end
end

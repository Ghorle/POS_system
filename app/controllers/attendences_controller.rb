class AttendencesController < ApplicationController
  before_action :set_attendence, only: %i[ show edit update destroy ]

  # GET /attendences or /attendences.json
  def index
    if current_user.has_role?(:admin)
      @attendences = Attendence.current_days
    else
      @attendences = current_user.attendences.current_days
    end
  end

  # GET /attendences/1 or /attendences/1.json
  def show
  end

  # GET /attendences/new
  def new
    @attendence = Attendence.new
  end

  # GET /attendences/1/edit
  def edit
  end

  # POST /attendences or /attendences.json
  def create
    @attendence = Attendence.new(attendence_params)

    respond_to do |format|
      if @attendence.save
        format.html { redirect_to attendence_url(@attendence), notice: "Attendence was successfully created." }
        format.json { render :show, status: :created, location: @attendence }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @attendence.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /attendences/1 or /attendences/1.json
  def update
    respond_to do |format|
      if @attendence.update(attendence_params)
        format.html { redirect_to attendence_url(@attendence), notice: "Attendence was successfully updated." }
        format.json { render :show, status: :ok, location: @attendence }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @attendence.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attendences/1 or /attendences/1.json
  def destroy
    @attendence.destroy

    respond_to do |format|
      format.html { redirect_to attendences_url, notice: "Attendence was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def user_attendence
    @user = User.find_by(email: params[:email])
    if @user.present?
      if @user.passcode == params[:passcode]
        if @user.attendences.current_days.last&.status == "in"
          @attendence = @user.attendences.new(remark: params[:remark], status: "out")
        else
          @attendence = @user.attendences.new(remark: params[:remark], status: "in")
        end
        respond_to do |format|
          if @attendence.save
            format.html { redirect_to attendences_url, notice: "Attendence Marked Successfully." }
            format.json { render :index, status: :created }
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @attendence.errors, status: :unprocessable_entity }
          end
        end
      else
        respond_to do |format|
          format.html { redirect_to new_attendence_url, notice: {error: "Wrong Passcode."} }
          format.json { render :new, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to new_attendence_url, notice: {error: "Invalid Email."} }
        format.json { render :new, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attendence
      @attendence = Attendence.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def attendence_params
      params.require(:attendence).permit(:remark, :type, :status, :user_id)
    end
end

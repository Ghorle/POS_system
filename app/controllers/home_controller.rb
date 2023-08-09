class HomeController < ApplicationController
  def index
  end

  def employees
    if params[:search].present?
      @employees = User.active.where("users.id = ? OR users.name ILIKE ?", "#{params[:search]}".to_i, "%#{params[:search]}%").with_role(:employee)
    else
      @employees = User.active.with_role(:employee)
    end
  end

  def inactive_employees
    if params[:search].present?
      @employees = User.inactive.where("users.id = ? OR users.name ILIKE ?", "#{params[:search]}".to_i, "%#{params[:search]}%").with_role(:employee)
    else
      @employees = User.inactive.with_role(:employee)
    end
  end

  def add_employee
    if params[:name].present? && params[:email].present?
      @user = User.where(name: params[:name], email: params[:email]).first_or_initialize
      password = rand(36**8).to_s(36)
      @user.password = password
      respond_to do |format|
        if @user.save!
          @user.add_role :employee
          UserMailer.employee_added(@user, password).deliver_now
          format.html { redirect_to employees_home_index_path, notice: "#{@user.name} added successfully." }
          format.json { render :show, status: :ok }
        else
          format.html { render :add_employee, status: :unprocessable_entity }
          format.json { render json: user.errors, status: :unprocessable_entity }
        end
      end
    else
      user = User.new
    end
  end

  def employee
    if current_user.has_role? :admin
      @employee = User.find(params[:id])
    else
      respond_to do |format|
        format.html { redirect_to root_path, notice: {error: "Unauthorized."} }
        format.json { render :index, status: :ok }
      end
    end
  end

  def mark_inactive
    if current_user.has_role? :admin
      @employee = User.find(params[:id])
      @employee.update!(status: "inactive")
      respond_to do |format|
        format.html { redirect_to employee_home_index_path(id: @employee.id), notice: "#{@employee.name} marked Inactive." }
        format.json { render :employee, status: :ok }
      end
    else
      respond_to do |format|
        format.html { redirect_to root_path, notice: {error: "Unauthorized."} }
        format.json { render :index, status: :ok }
      end
    end
  end

  def mark_active
    if current_user.has_role? :admin
      @employee = User.find(params[:id])
      @employee.update!(status: "active")
      respond_to do |format|
        format.html { redirect_to employee_home_index_path(id: @employee.id), notice: "#{@employee.name} marked Active." }
        format.json { render :employee, status: :ok }
      end
    else
      respond_to do |format|
        format.html { redirect_to root_path, notice: {error: "Unauthorized."} }
        format.json { render :index, status: :ok }
      end
    end
  end
end

class HomeController < ApplicationController
  def index
  end

  def employees
    @employees = User.with_role(:employee)
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
end

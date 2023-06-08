class Admins::AdminsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :authenticate_admin!
  before_action :ensure_correct_admin, only: [:destroy]

  def dashboard
  end

  def users
    @users = User.all
  end

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(admin_params)
    if @admin.save
      redirect_to admins_dashboard_path, notice: "Admin was successfully created."
    else
      render :new
    end
  end

  def destroy
    @admin = Admin.find(params[:id])
    @admin.destroy
    redirect_to admins_dashboard_path, notice: "Admin was successfully destroyed."
  end

  private

  def admin_params
    params.require(:admin).permit(:name, :email, :password, :password_confirmation)
  end

  def ensure_correct_admin
    @admin = Admin.find(params[:id])
    if @admin.email == ENV['ADMIN_EMAIL']
      redirect_to admins_dashboard_path, notice: "You can't delete first admin."
    end
  end
end

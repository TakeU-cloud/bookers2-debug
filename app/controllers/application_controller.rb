class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:top, :about], unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def authenticate_admin!
    unless admin_signed_in?
      redirect_to root_path, notice: "You have no permission."
    end
  end

  private

  def after_sign_in_path_for(resource)
    if resource.is_a?(Admin)
      admins_dashboard_path
    else
      user_path(resource.id)
    end
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email])
  end
end

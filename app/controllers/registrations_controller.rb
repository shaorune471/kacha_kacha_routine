class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    session[:onboarding] = true
    guide_path
  end
end

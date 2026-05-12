class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :google_oauth2

  def google_oauth2
    auth = request.env["omniauth.auth"]

    if auth.nil?
      redirect_to root_path, alert: "Google認証に失敗しました。"
      return
    end

    is_new_user = !User.exists?(provider: auth.provider, uid: auth.uid)
    @user = User.from_omniauth(auth)

    if @user.persisted?
      sign_in @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
      if is_new_user
        session[:onboarding] = true
        redirect_to guide_path
      else
        redirect_to home_path
      end
    else
      session["devise.google_data"] = auth.except(:extra)
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end

  def failure
    redirect_to root_path, alert: "Google認証に失敗しました。"
  end
end

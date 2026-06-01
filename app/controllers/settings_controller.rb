class SettingsController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def update
    if current_user.update_with_password_check(settings_params.to_h)
      bypass_sign_in(current_user)
      redirect_to settings_path, notice: "設定を更新しました"
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def settings_params
    params.require(:user).permit(
      :habit_limit, :reengagement_notification, :reminder_notification,
      :dark_mode, :review_start_day, :name, :email,
      :password, :password_confirmation, :current_password
    )
  end
end

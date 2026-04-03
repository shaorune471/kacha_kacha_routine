class HomesController < ApplicationController
  before_action :authenticate_user!

  def index
    @habits = current_user.habits
    @total_experience = current_user.total_experience
    @checked_today_count = @habits.count(&:checked_today?)
    @show_reframing_banner = Date.today.sunday?
  end
end

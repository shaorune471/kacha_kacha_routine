class HomesController < ApplicationController
  before_action :authenticate_user!

  def index
    @q = Habit.ransack(params[:q])
    @all_habits = current_user.habits
    @habits = @q.result(distinct: true).where(user: current_user)
    @total_experience = current_user.total_experience
    @checked_today_count = @all_habits.count(&:checked_today?)
    @show_reframing_banner = Date.today.sunday?
  end
end

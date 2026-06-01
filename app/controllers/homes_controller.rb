class HomesController < ApplicationController
  before_action :authenticate_user!

  def index
    @q = Habit.ransack(params[:q])
    @all_habits = current_user.habits.where(status: :active)
    @selected_statuses = params[:status].present? ? Array(params[:status]) : [ "active" ]
    @habits = @q.result(distinct: true).where(user: current_user, status: @selected_statuses).order(status: :asc, id: :asc)
    @total_experience = current_user.total_experience
    @checked_today_count = @all_habits.count(&:checked_today?)
    @show_reframing_banner = Date.today.sunday?
  end

  def autocomplete
    @habits = Habit.ransack(title_cont: params[:q])
      .result(distinct: true)
      .where(user: current_user)
      .limit(5)
    render layout: false
  end
end

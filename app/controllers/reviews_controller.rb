class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def index
    @habits = current_user.habits
  end

  def show
    @habit = current_user.habits.find(params[:habit_id])
    @habit_checks = @habit.habit_checks.order(checked_on: :desc)
  end
end

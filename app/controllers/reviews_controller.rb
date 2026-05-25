class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def index
    @habits = current_user.habits
  end

  def show
    @habit = Habit.find(params[:habit_id])
    authorize @habit, policy_class: ReviewPolicy
    @habit_checks = @habit.habit_checks.order(checked_on: :desc)
    @review_start_day = current_user.review_start_day
    week_seed = Date.today.beginning_of_week.to_time.to_i
    @advices = REVIEW_ADVICE.sample(3, random: Random.new(week_seed))
  end
end

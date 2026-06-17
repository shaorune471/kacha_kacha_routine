class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def index
    @active_habits = current_user.habits.where(status: :active).order(id: :asc)
    @paused_habits = current_user.habits.where(status: :paused).order(id: :asc)
    @completed_habits = current_user.habits.where(status: :completed).order(id: :asc)
  end

  def show
    @habit = Habit.find(params[:habit_id])
    authorize @habit, policy_class: ReviewPolicy
    @habit_checks = @habit.habit_checks.order(checked_on: :desc)
    @review_start_day = current_user.review_start_day
    week_seed = Date.today.beginning_of_week(User::WEEK_START_DAYS[@review_start_day]).to_time.to_i
    @advices = REVIEW_ADVICE.sample(3, random: Random.new(week_seed))
  end
end

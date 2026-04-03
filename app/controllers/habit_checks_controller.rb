class HabitChecksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_habit

  def new
    @habit_check = HabitCheck.new(checked_on: Date.today)
  end

  def create
    @habit_check = @habit.habit_checks.new(habit_check_params)
    @habit_check.checked_on = Date.today

    if @habit_check.save
      redirect_to home_path, notice: "チェックを記録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_habit
    @habit = current_user.habits.find(params[:habit_id])
  end

  def habit_check_params
    params.require(:habit_check).permit(:evaluation, :exception_content, :exception_condition, :memo)
  end
end

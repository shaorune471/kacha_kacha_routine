class HabitChecksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_habit

  def new
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    today_check = @habit.habit_checks.find_by(checked_on: @date)
    if today_check
      redirect_to edit_habit_habit_check_path(@habit, today_check)
      return
    end
    @habit_check = @habit.habit_checks.build(checked_on: @date)
    authorize @habit_check
  end

  def create
    @habit_check = @habit.habit_checks.new(habit_check_params)
    @habit_check.checked_on = params[:habit_check][:checked_on] || Date.today
    @date = @habit_check.checked_on
    authorize @habit_check
    if @habit_check.save
      redirect_to after_save_path, notice: "チェックを記録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @habit_check = @habit.habit_checks.find(params[:id])
    authorize @habit_check
  end

  def update
    @habit_check = @habit.habit_checks.find(params[:id])
    authorize @habit_check
    if @habit_check.update(habit_check_params)
      redirect_to after_save_path, notice: "チェックを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_habit
    @habit = Habit.find(params[:habit_id])
  end

  def habit_check_params
    params.require(:habit_check).permit(:evaluation, :exception_content, :exception_condition, :memo, :checked_on)
  end

  def after_save_path
    if params[:from] == "calendar"
      calendar_path(habit_id: @habit.id, start_date: @habit_check.checked_on.beginning_of_month)
    else
      home_path
    end
  end
end

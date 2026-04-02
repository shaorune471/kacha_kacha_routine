class HabitsController < ApplicationController
  before_action :authenticate_user!

  def new
    @habit = Habit.new
  end

  def create
    @habit = current_user.habits.new(habit_params)
    if @habit.save
      redirect_to home_path, notice: "習慣を登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def habit_params
    params.require(:habit).permit(:title, :content, :minimum_goal, :exception_rule)
  end
end

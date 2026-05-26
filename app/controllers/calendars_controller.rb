class CalendarsController < ApplicationController
  before_action :authenticate_user!

  def index
    @habits = current_user.habits
    @habit = params[:habit_id] ? current_user.habits.find(params[:habit_id]) : @habits.first

    if @habit
      @habit_checks = @habit.habit_checks
        .order(:checked_on)
        .group_by(&:checked_on)

      @reopen_dates = calculate_reopen_dates
    end
  end

  private

  def calculate_reopen_dates
    sorted_checks = @habit.habit_checks.order(:checked_on)
    reopen_dates = []

    sorted_checks.each_with_index do |check, i|
      next unless check.all_achieved? || check.minimum_achieved?
      next if i == 0

      prev_check = sorted_checks[i - 1]
      if !(prev_check.all_achieved? || prev_check.minimum_achieved?) || (check.checked_on - prev_check.checked_on) > 1
        reopen_dates << check.checked_on
      end
    end

    reopen_dates
  end
end

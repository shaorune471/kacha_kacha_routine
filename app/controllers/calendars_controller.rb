class CalendarsController < ApplicationController
  before_action :authenticate_user!

  def index
    @habits = current_user.habits.order(status: :asc, id: :asc)
    @habit = if params[:habit_id]
      current_user.habits.find(params[:habit_id])
    else
      current_user.habits.where(status: :active).first ||
      current_user.habits.where(status: :paused).first ||
      current_user.habits.where(status: :completed).first
    end
    @current_month = (params[:start_date] ? Date.parse(params[:start_date]) : Date.today).beginning_of_month

    if @habit
      @habit_checks = @habit.habit_checks
        .order(:checked_on)
        .group_by(&:checked_on)
      @reopen_dates = calculate_reopen_dates
      @first_check_date = @habit.habit_checks.order(:checked_on).first&.checked_on || Date.today
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

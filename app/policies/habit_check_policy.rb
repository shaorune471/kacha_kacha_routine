class HabitCheckPolicy < ApplicationPolicy
  def new?
    record.habit.user == user
  end

  def create?
    record.habit.user == user
  end

  def edit?
    record.habit.user == user
  end

  def update?
    record.habit.user == user
  end
end

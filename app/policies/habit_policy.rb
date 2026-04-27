class HabitPolicy < ApplicationPolicy
  def new?
    true
  end

  def create?
    true
  end

  def show?
    record.user == user
  end

  def edit?
    record.user == user
  end

  def update?
    record.user == user
  end

  def destroy?
    record.user == user
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(user: user)
    end
  end
end

class ReviewPolicy < ApplicationPolicy
  def show?
    record.user == user
  end
end

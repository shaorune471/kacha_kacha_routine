class Habit < ApplicationRecord
  belongs_to :user
  has_many :habit_checks, dependent: :destroy

  validates :title, presence: true, uniqueness: { scope: :user_id, message: "はすでに登録されています" }
  validates :content, presence: true
  validates :minimum_goal, presence: true

  def checked_today?
    habit_checks.exists?(checked_on: Date.today)
  end
end

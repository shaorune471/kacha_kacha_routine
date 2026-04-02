class Habit < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, uniqueness: { scope: :user_id, message: "はすでに登録されています" }
  validates :content, presence: true
  validates :minimum_goal, presence: true
end

class HabitCheck < ApplicationRecord
  belongs_to :habit

  enum evaluation: { all_achieved: 0, minimum_achieved: 1, exception: 2, room_for_growth: 3 }

  validates :checked_on, presence: true,
            uniqueness: { scope: :habit_id, message: "本日はすでにチェック済みです" }
  validates :evaluation, presence: true
end

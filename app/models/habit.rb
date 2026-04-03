class Habit < ApplicationRecord
  belongs_to :user
  has_many :habit_checks, dependent: :destroy

  validates :title, presence: true, uniqueness: { scope: :user_id, message: "はすでに登録されています" }
  validates :content, presence: true
  validates :minimum_goal, presence: true

  def checked_today?
    habit_checks.exists?(checked_on: Date.today)
  end

  def total_points
    # 習慣チェックをチェック日の昇順でソート
    sorted_checks = habit_checks.order(:checked_on)
    score = 0

    sorted_checks.each_with_index do |check, i|
      next unless achieved?(check)

      # 全て・最低ライン達成で+1pt、前回の習慣チェックが未達成で+2pt（初日は1pt固定）
      if i == 0 || achieved?(sorted_checks[i - 1])
        score += 1
      else
        score += 2
      end
    end

    score
  end

  def points_for_week(week_start)
    # 一週間分の習慣チェックを取得
    week_end = week_start + 6.days
    sorted_checks = habit_checks.order(:checked_on)
    week_checks = sorted_checks.select { |hc| hc.checked_on.between?(week_start, week_end) }
    score = 0

    week_checks.each do |check|
      next unless achieved?(check)
      # 達成した日の前回の習慣チェックを取得
      prev_check = sorted_checks.select { |hc| hc.checked_on < check.checked_on }.last

      # 前回の習慣チェックがない（初日）または達成していれば+1pt
      if prev_check.nil? || achieved?(prev_check)
        score += 1
      else
        score += 2
      end
    end

    score
  end

  private

  def achieved?(check)
    check.all_achieved? || check.minimum_achieved?
  end
end

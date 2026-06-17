class Habit < ApplicationRecord
  belongs_to :user
  has_many :habit_checks, dependent: :destroy

  validates :title, presence: true, uniqueness: { scope: :user_id, message: "はすでに登録されています" }
  validates :content, presence: true
  validates :minimum_goal, presence: true

  validate :minimum_goal_validates
  validate :habits_count_limit, on: :create

  HABIT_LIMIT = 5
  GOAL_DAYS_OPTIONS = [
    [ "設定なし", nil ],
    [ "1週間（7日）", 7 ],
    [ "2週間（14日）", 14 ],
    [ "1ヶ月（30日）", 30 ],
    [ "66日", 66 ]
  ].freeze

  enum :status, { active: 0, paused: 1, completed: 2 }

  def checked_today?
    habit_checks.exists?(checked_on: Date.today)
  end

  def total_points
    # 習慣チェックをチェック日の昇順でソート
    sorted_checks = habit_checks.order(:checked_on)
    score = 0

    sorted_checks.each_with_index do |check, i|
      next unless achieved?(check)
      prev_check = sorted_checks[i - 1]

      if i == 0
        # 初日は1pt固定
        score += 1
      elsif !achieved?(prev_check) || (check.checked_on - prev_check.checked_on) > 1
        # 前回チェックが未達成、または前回チェックから2日以上経過した場合は+2pt
        score += 2
      else
        score += 1
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

      if prev_check.nil?
        # 前回のチェックがない（初日）
        score += 1
      elsif !achieved?(prev_check) || (check.checked_on - prev_check.checked_on) > 1
        # 前回のチェックが未達成または前回チェックから2日以上経過した場合は+2pt
        # 週の初日でも再開で+2ptになる場合がある
        score += 2
      else
        # 前回のチェックが達成
        score += 1
      end
    end

    score
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "title", "content", "minimum_goal" ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  def goal_start_date
    habit_checks.order(:checked_on).first&.checked_on
  end

  def goal_progress_percentage
    return 0 unless goal_days.present? && total_points > 0
    [ (total_points.to_f / goal_days * 100).round, 100 ].min
  end

  private

  def achieved?(check)
    check.all_achieved? || check.minimum_achieved?
  end

  def minimum_goal_validates
    if content.present? && minimum_goal.present? && content == minimum_goal
      errors.add(:minimum_goal, "は習慣内容と違う内容にしてください")
    end
  end

  def habits_count_limit
    return unless user.habit_limit?
    if user.habits.where(status: :active).count >= HABIT_LIMIT
      errors.add(:base, "継続中の習慣は#{HABIT_LIMIT}個までです。今の習慣を優先しましょう。設定で変更もできます。")
    end
  end
end

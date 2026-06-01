class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :google_oauth2 ]

  has_many :habits, dependent: :destroy

  validates :name, presence: true

  DAYS_OF_WEEK = {
    0 => "日曜日",
    1 => "月曜日",
    2 => "火曜日",
    3 => "水曜日",
    4 => "木曜日",
    5 => "金曜日",
    6 => "土曜日"
  }

  LEVELS = [
    { min: 0,   max: 9,  level: 1, title: "最初の一歩" },
    { min: 10,  max: 29,  level: 2, title: "歩み始めた" },
    { min: 30,  max: 69,  level: 3, title: "自分のペースを掴んでいる" },
    { min: 70,  max: 139, level: 4, title: "何度でも前に進める" },
    { min: 140, max: Float::INFINITY, level: 5, title: "不屈の歩み" }
  ].freeze

  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first_or_initialize do |u|
      u.email = auth.info.email
      u.password = Devise.friendly_token[0, 20]
      u.name = auth.info.name
    end
    user.save if user.new_record?
    user
  end

  def total_experience
    habits.sum(&:total_points)
  end

  def current_level
    LEVELS.find { |l| total_experience.between?(l[:min], l[:max]) }
  end

  def level_number
    current_level[:level]
  end

  def level_title
    current_level[:title]
  end

  def next_level
    LEVELS.find { |l| l[:level] == level_number + 1 }
  end

  def level_progress_percentage
    return 100 if level_number == 5
    current = current_level
    exp_in_level = total_experience - current[:min]
    level_range = current[:max] - current[:min]
    [ (exp_in_level.to_f / level_range * 100).round, 100 ].min
  end

  def update_with_password_check(params)
    if params[:password].present?
      update_with_password(params)
    else
      params.delete(:current_password)
      params.delete(:password)
      params.delete(:password_confirmation)
      update(params)
    end
  end
end

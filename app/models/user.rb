class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :google_oauth2 ]

  has_many :habits, dependent: :destroy

  DAYS_OF_WEEK = {
    0 => "日曜日",
    1 => "月曜日",
    2 => "火曜日",
    3 => "水曜日",
    4 => "木曜日",
    5 => "金曜日",
    6 => "土曜日"
  }

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
end

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :habits, dependent: :destroy

  def total_experience
    habits.sum(&:total_points)
  end
end

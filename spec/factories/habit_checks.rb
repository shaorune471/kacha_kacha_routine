FactoryBot.define do
  factory :habit_check do
    association :habit
    checked_on { Date.today }
    evaluation { :all_achieved }
  end
end

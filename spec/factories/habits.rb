FactoryBot.define do
  factory :habit do
    association :user
    title { Faker::Lorem.unique.word }
    content { Faker::Lorem.sentence }
    minimum_goal { Faker::Lorem.sentence }
    exception_rule { Faker::Lorem.sentence }
  end
end

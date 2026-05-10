require "rails_helper"

RSpec.describe HabitCheck, type: :model do
  describe "バリデーション" do
    it "習慣の評価が必須" do
      habit_check = build(:habit_check)
      expect(habit_check).to be_valid
    end

    it "同じ習慣の同じ日付は無効" do
      habit = create(:habit)
      create(:habit_check, habit: habit, checked_on: Date.today)
      habit_check = build(:habit_check, habit: habit, checked_on: Date.today)
      expect(habit_check).not_to be_valid
    end

    it "同じ習慣でも異なる日付は有効" do
      habit = create(:habit)
      create(:habit_check, habit: habit, checked_on: Date.today - 1)
      habit_check = build(:habit_check, habit: habit, checked_on: Date.today)
      expect(habit_check).to be_valid
    end
  end
end

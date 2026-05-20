require "rails_helper"

RSpec.describe Habit, type: :model do
  describe "バリデーション" do
    it "タイトルが必須" do
      habit = build(:habit, title: nil)
      expect(habit).not_to be_valid
    end

    it "習慣内容が必須" do
      habit = build(:habit, content: nil)
      expect(habit).not_to be_valid
    end

    it "最低目標が必須" do
      habit = build(:habit, minimum_goal: nil)
      expect(habit).not_to be_valid
    end

    it "タイトル・習慣内容・最低目標が必須" do
      habit = build(:habit)
      expect(habit).to be_valid
    end

    it "同じユーザーで重複したタイトルは無効" do
      user = create(:user)
      create(:habit, user: user, title: "読書")
      habit = build(:habit, user: user, title: "読書")
      expect(habit).not_to be_valid
    end

    it "異なるユーザーで同じタイトルなら有効" do
      create(:habit, title: "読書")
      habit = build(:habit, title: "読書")
      expect(habit).to be_valid
    end
  end

  describe "習慣チェックの判定" do
    let(:habit) { create(:habit) }

    it "今日チェック済みの場合はtrueを返す" do
      create(:habit_check, habit: habit, checked_on: Date.today)
      expect(habit.checked_today?).to be true
    end

    it "今日チェックしていない場合はfalseを返す" do
      expect(habit.checked_today?).to be false
    end
  end

  describe "習慣ポイントの計算" do
    let(:habit) { create(:habit) }

    it "チェックがない場合は0を返す" do
      expect(habit.total_points).to eq(0)
    end

    it "全て達成で+1ptを返す" do
      create(:habit_check, habit: habit, checked_on: Date.today - 1, evaluation: :all_achieved)
      expect(habit.total_points).to eq(1)
    end

    it "最低目標達成で+1ptを返す" do
      create(:habit_check, habit: habit, checked_on: Date.today - 1, evaluation: :minimum_achieved)
      expect(habit.total_points).to eq(1)
    end

    it "未達成は0ptを返す" do
      create(:habit_check, habit: habit, checked_on: Date.today - 1, evaluation: :room_for_growth)
      expect(habit.total_points).to eq(0)
    end

    it "○××○の場合は+1+0+0+2=3ptを返す" do
      create(:habit_check, habit: habit, checked_on: Date.today - 4, evaluation: :all_achieved)
      create(:habit_check, habit: habit, checked_on: Date.today - 3, evaluation: :room_for_growth)
      create(:habit_check, habit: habit, checked_on: Date.today - 2, evaluation: :room_for_growth)
      create(:habit_check, habit: habit, checked_on: Date.today - 1, evaluation: :all_achieved)
      expect(habit.total_points).to eq(3)
    end
  end

  describe "習慣数の上限" do
    let(:user) { create(:user, habit_limit: true) }

    it "上限以下であれば登録できる" do
      create_list(:habit, Habit::HABIT_LIMIT - 1, user: user)
      habit = build(:habit, user: user)
      expect(habit).to be_valid
    end

    it "上限を超えると登録できない" do
      create_list(:habit, Habit::HABIT_LIMIT, user: user)
      habit = build(:habit, user: user)
      expect(habit).not_to be_valid
    end

    it "上限なしの場合は上限を超えても登録できる" do
      user.update(habit_limit: false)
      create_list(:habit, Habit::HABIT_LIMIT, user: user)
      habit = build(:habit, user: user)
      expect(habit).to be_valid
    end
  end
end

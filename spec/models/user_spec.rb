require "rails_helper"

RSpec.describe User, type: :model do
  describe "バリデーション" do
    it "名前・メール・パスワードが必須" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "メールアドレスが重複している場合は無効" do
      create(:user, email: "test@example.com")
      user = build(:user, email: "test@example.com")
      expect(user).not_to be_valid
    end
  end

  describe "習慣ポイントの計算" do
    it "全ての習慣ポイントの合計を返す" do
      user = create(:user)
      habit1 = create(:habit, user: user)
      habit2 = create(:habit, user: user)
      create(:habit_check, habit: habit1, checked_on: Date.today - 1, evaluation: :all_achieved)
      create(:habit_check, habit: habit2, checked_on: Date.today - 1, evaluation: :minimum_achieved)
      expect(user.total_experience).to eq(2)
    end
  end

  describe "振り返りの開始曜日" do
    it "デフォルトは月曜日（1）である" do
      user = create(:user)
      expect(user.review_start_day).to eq(1)
    end
  end
end

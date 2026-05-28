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

  describe "レベルアップ機能" do
    let(:user) { create(:user) }

    it "経験値0でレベル1かつ称号が正しい" do
      expect(user.level_number).to eq(1)
      expect(user.level_title).to eq("最初の一歩")
    end

    it "経験値10でレベル2かつ称号が正しい" do
      allow(user).to receive(:total_experience).and_return(10)
      expect(user.level_number).to eq(2)
      expect(user.level_title).to eq("歩み始めた")
    end

    it "経験値140でレベル5かつ称号が正しい" do
      allow(user).to receive(:total_experience).and_return(140)
      expect(user.level_number).to eq(5)
      expect(user.level_title).to eq("不屈の歩み")
    end

    it "レベル5では次のレベルがない" do
      allow(user).to receive(:total_experience).and_return(140)
      expect(user.next_level).to be_nil
    end

    it "進捗率が正しく計算される" do
      allow(user).to receive(:total_experience).and_return(19)
      expect(user.level_progress_percentage).to eq(47)
    end
  end
end

require "rails_helper"

RSpec.describe "習慣チェック", type: :system do
  let(:user) { create(:user) }
  let(:habit) { create(:habit, user: user) }

  before do
    login_as user, scope: :user
  end

  describe "習慣チェックの登録" do
    it "正常に習慣チェックを登録できる" do
      visit new_habit_habit_check_path(habit)
      choose "全ての習慣を達成"
      click_button "登録"
      expect(page).to have_content "チェックを記録しました"
    end
  end

  describe "習慣チェックの更新" do
    let!(:habit_check) { create(:habit_check, habit: habit, checked_on: Date.today) }

    it "正常に習慣チェックを更新できる" do
      visit edit_habit_habit_check_path(habit, habit_check)
      choose option: "minimum_achieved"
      click_button "更新"
      expect(page).to have_content "チェックを更新しました"
    end
  end
end

require "rails_helper"

RSpec.describe "習慣管理", type: :system do
  let(:user) { create(:user) }

  before do
    login_as user, scope: :user
  end

  describe "習慣の登録" do
    it "正常に習慣を登録できる" do
      visit new_habit_path
      fill_in "habit_title", with: "毎日読書する"
      fill_in "habit_content", with: "本を読む習慣をつける"
      fill_in "habit_minimum_goal", with: "1ページだけ読む"
      click_button "登録"
      expect(page).to have_content "習慣を登録しました"
    end

    it "タイトルがなければ登録できない" do
      visit new_habit_path
      fill_in "habit_content", with: "本を読む習慣をつける"
      fill_in "habit_minimum_goal", with: "1ページだけ読む"
      click_button "登録"
      expect(page).to have_content "習慣タイトル を入力してください"
    end
  end

  describe "習慣の編集" do
    let(:habit) { create(:habit, user: user) }

    it "正常に習慣を編集できる" do
      visit edit_habit_path(habit)
      fill_in "習慣タイトル", with: "更新後のタイトル"
      click_button "更新"
      expect(page).to have_content "習慣を更新しました"
    end
  end

  describe "習慣の削除" do
    let(:habit) { create(:habit, user: user) }

    it "正常に習慣を削除できる" do
      visit habit_path(habit)
      accept_confirm do
        click_button "削除"
      end
      expect(page).to have_content "習慣を削除しました"
    end
  end

  describe "習慣の検索" do
    let!(:habit1) { create(:habit, user: user, title: "毎日読書する", content: "本を読む") }
    let!(:habit2) { create(:habit, user: user, title: "朝のストレッチ", content: "体を動かす") }

    it "タイトルで検索できる" do
      visit home_path
      fill_in "q[title_or_content_cont]", with: "読書"
      click_button "検索"
      expect(page).to have_content "毎日読書する"
      expect(page).not_to have_content "朝のストレッチ"
    end

    it "内容で検索できる" do
      visit home_path
      fill_in "q[title_or_content_cont]", with: "体を動かす"
      click_button "検索"
      expect(page).to have_content "朝のストレッチ"
      expect(page).not_to have_content "毎日読書する"
    end
  end

  describe "オートコンプリート" do
    let!(:habit1) { create(:habit, user: user, title: "毎日読書する", content: "本を読む") }
    let!(:habit2) { create(:habit, user: user, title: "朝のストレッチ", content: "体を動かす") }

    it "入力した文字に合う候補が表示される" do
      visit home_path
      fill_in "q[title_or_content_cont]", with: "読書"
      expect(page).to have_content "毎日読書する"
    end
  end
end

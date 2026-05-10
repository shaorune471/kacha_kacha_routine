require "rails_helper"

RSpec.describe "ユーザー認証", type: :system do
  describe "新規登録" do
    it "正常に新規登録できる" do
      visit root_path
      click_link "新規登録"
      fill_in "名前", with: "テストユーザー"
      fill_in "メールアドレス", with: "test@example.com"
      fill_in "パスワード", with: "password"
      fill_in "パスワード確認", with: "password"
      click_button "登録"
      expect(page).to have_content "アプリの使い方"
    end
  end

  describe "ログイン" do
    let(:user) { create(:user) }

    it "正常にログインできる" do
      visit root_path
      click_link "ログイン"
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: "password"
      click_button "ログイン"
      expect(page).to have_content "ホーム"
    end

    it "誤ったパスワードではログインできない" do
      visit root_path
      click_link "ログイン"
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: "wrongpassword"
      click_button "ログイン"
      expect(page).to have_content "メールアドレスまたはパスワードが違います"
    end
  end

  describe "ログアウト" do
    let(:user) { create(:user) }

    it "正常にログアウトできる" do
      login_as user, scope: :user
      visit home_path
      click_button "ログアウト"
      expect(page).to have_content "ログアウトしました"
    end
  end
end

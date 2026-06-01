require "rails_helper"

RSpec.describe "設定", type: :system do
  let(:user) { create(:user) }

  before do
    login_as user, scope: :user
  end

  it "設定画面が表示される" do
    visit settings_path
    expect(page).to have_content "設定"
  end

  it "設定を保存できる" do
    visit settings_path
    click_button "設定を保存"
    expect(page).to have_content "設定を更新しました"
  end

  it "設定画面からログアウトできる" do
    visit settings_path
    click_button "ログアウト"
    expect(page).to have_content "ログアウトしました"
  end

  it "振り返りの開始曜日を変更できる" do
    visit settings_path
    select "日曜日", from: "user[review_start_day]"
    click_button "設定を保存"
    expect(page).to have_content "設定を更新しました"
    expect(user.reload.review_start_day).to eq(0)
  end

  it "名前を変更できる" do
    visit settings_path
    fill_in "名前", with: "新しい名前"
    click_button "設定を保存"
    expect(page).to have_content "設定を更新しました"
    expect(user.reload.name).to eq("新しい名前")
  end

  it "名前が空白の場合は保存できない" do
    visit settings_path
    fill_in "名前", with: ""
    click_button "設定を保存"
    expect(page).to have_content "を入力してください"
  end

  it "パスワードを変更できる" do
    visit settings_path
    fill_in "現在のパスワード", with: "password"
    fill_in "新しいパスワード", with: "newpassword"
    fill_in "新しいパスワード確認", with: "newpassword"
    click_button "設定を保存"
    expect(page).to have_content "設定を更新しました"
  end

  it "現在のパスワードが誤っている場合は変更できない" do
    visit settings_path
    fill_in "現在のパスワード", with: "wrongpassword"
    fill_in "新しいパスワード", with: "newpassword"
    fill_in "新しいパスワード確認", with: "newpassword"
    click_button "設定を保存"
    expect(page).to have_content "は不正な値です"
  end

  it "パスワードが空白の場合は他の設定のみ保存できる" do
    visit settings_path
    click_button "設定を保存"
    expect(page).to have_content "設定を更新しました"
  end
end

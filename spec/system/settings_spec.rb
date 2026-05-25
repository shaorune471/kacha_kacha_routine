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
end

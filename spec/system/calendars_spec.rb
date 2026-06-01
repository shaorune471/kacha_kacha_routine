require "rails_helper"

RSpec.describe "カレンダー", type: :system do
  let(:user) { create(:user) }
  let(:habit) { create(:habit, user: user) }

  before do
    login_as user, scope: :user
  end

  it "カレンダー画面が表示される" do
    visit calendar_path
    expect(page).to have_content "カレンダー"
  end

  it "習慣を選択するとカレンダーが表示される" do
    habit
    visit calendar_path
    expect(page).to have_content habit.title
  end

  it "チェック済みの日付をクリックすると編集画面に遷移する" do
    habit_check = create(:habit_check, habit: habit, checked_on: Date.today)
    visit calendar_path(habit_id: habit.id)
    find("a[href*='habit_checks/#{habit_check.id}/edit']").click
    expect(page).to have_content "習慣チェック"
  end

  it "過去の未チェック日付をクリックすると新規チェック画面に遷移する" do
    past_date = Date.today - 2
    create(:habit_check, habit: habit, checked_on: Date.today - 3, evaluation: :all_achieved)
    visit calendar_path(habit_id: habit.id)
    expect(page).to have_css("a[href*='date=#{past_date}']")
  end
end

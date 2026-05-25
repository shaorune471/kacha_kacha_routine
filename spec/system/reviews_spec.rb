require "rails_helper"

RSpec.describe "振り返り", type: :system do
  let(:user) { create(:user) }
  let(:habit) { create(:habit, user: user) }

  before do
    login_as user, scope: :user
  end

  describe "振り返り一覧" do
    it "振り返り一覧が表示される" do
      visit reviews_path
      expect(page).to have_content "振り返り"
    end
  end

  describe "振り返り詳細" do
    it "アドバイスが3つ表示される" do
      visit habit_review_path(habit, habit)
      expect(page).to have_css(".space-y-2 li", count: 3)
    end
  end
end

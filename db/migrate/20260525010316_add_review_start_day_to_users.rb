class AddReviewStartDayToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :review_start_day, :integer, default: 1, null: false
  end
end

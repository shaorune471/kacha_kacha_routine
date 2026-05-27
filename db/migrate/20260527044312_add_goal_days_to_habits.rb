class AddGoalDaysToHabits < ActiveRecord::Migration[7.2]
  def change
    add_column :habits, :goal_days, :integer, default: nil
  end
end

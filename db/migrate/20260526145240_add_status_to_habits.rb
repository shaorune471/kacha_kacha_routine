class AddStatusToHabits < ActiveRecord::Migration[7.2]
  def change
    add_column :habits, :status, :integer, default: 0, null: false
  end
end

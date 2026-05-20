class AddSettingsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :habit_limit, :boolean, default: true, null: false
    add_column :users, :reengagement_notification, :boolean, default: true, null: false
    add_column :users, :reminder_notification, :boolean, default: true, null: false
    add_column :users, :dark_mode, :boolean, default: false, null: false
  end
end

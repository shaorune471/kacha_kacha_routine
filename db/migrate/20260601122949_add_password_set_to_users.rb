class AddPasswordSetToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :password_set, :boolean, default: false, null: false
  end
end

class CreateHabits < ActiveRecord::Migration[7.2]
  def change
    create_table :habits do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :content, null: false
      t.string :minimum_goal, null: false
      t.text :exception_rule

      t.timestamps
    end
  end
end

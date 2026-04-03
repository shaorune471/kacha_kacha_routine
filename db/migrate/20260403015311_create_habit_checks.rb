class CreateHabitChecks < ActiveRecord::Migration[7.2]
  def change
    create_table :habit_checks do |t|
      t.references :habit, null: false, foreign_key: true
      t.date :checked_on, null: false
      t.integer :evaluation, null: false
      t.string :exception_content
      t.string :exception_condition
      t.text :memo

      t.timestamps
    end

    add_index :habit_checks, [ :habit_id, :checked_on ], unique: true
  end
end

class CreateStudySessions < ActiveRecord::Migration[7.1]
  def change
    create_table :study_sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :duration
      t.datetime :studied_at
      t.text :note

      t.timestamps
    end
  end
end

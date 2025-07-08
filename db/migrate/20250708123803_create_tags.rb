class CreateTags < ActiveRecord::Migration[7.1]
  def change
    create_table :tags do |t|
      t.string :name
      t.text :description
      t.string :color
      t.boolean :is_preset

      t.timestamps
    end
  end
end

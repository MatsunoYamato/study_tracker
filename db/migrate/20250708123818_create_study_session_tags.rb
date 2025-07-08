class CreateStudySessionTags < ActiveRecord::Migration[7.1]
  def change
    create_table :study_session_tags do |t|
      t.references :study_session, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end

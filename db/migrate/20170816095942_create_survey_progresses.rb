class CreateSurveyProgresses < ActiveRecord::Migration[5.1]
  def change
    create_table :survey_progresses do |t|
      t.integer :status, default: 0, null: false, limit: 1
      t.references :user
      t.references :survey
      t.timestamps
    end
  end
end

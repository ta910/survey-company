class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions do |t|
      t.string :name, null: false
      t.integer :status, default: 0, null: false, limit: 1
      t.references :survey
      t.timestamps
    end
  end
end

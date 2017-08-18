class CreateAnswerTexts < ActiveRecord::Migration[5.1]
  def change
    create_table :answer_texts do |t|
      t.string :text
      t.references :user
      t.references :question
      t.timestamps
    end
  end
end

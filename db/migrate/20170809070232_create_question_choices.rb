class CreateQuestionChoices < ActiveRecord::Migration[5.1]
  def change
    create_table :question_choices do |t|
      t.string :text
      t.references :question
      t.timestamps
    end
  end
end

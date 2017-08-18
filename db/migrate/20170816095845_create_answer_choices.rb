class CreateAnswerChoices < ActiveRecord::Migration[5.1]
  def change
    create_table :answer_choices do |t|
      t.references :user
      t.references :question_choice
      t.timestamps
    end
  end
end

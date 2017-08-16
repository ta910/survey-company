class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.string :body
      t.string :image
      t.references :user
      t.timestamps
    end
  end
end

class CreateMessageImages < ActiveRecord::Migration[5.1]
  def change
    create_table :message_images do |t|
      t.string :body, null: false
      t.references :message
      t.timestamps
    end
  end
end

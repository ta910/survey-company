class AddColumnToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :sender_id, :integer
    rename_column :messages, :user_id, :recipient_id
    add_foreign_key :messages, :users, column: :sender_id
  end
end

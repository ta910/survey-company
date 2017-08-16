class RemoveBodyFromMessages < ActiveRecord::Migration[5.1]
  def change
    remove_column :messages, :body, :string
    remove_column :messages, :image, :string
  end
end

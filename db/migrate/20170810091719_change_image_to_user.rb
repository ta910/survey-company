class ChangeImageToUser < ActiveRecord::Migration[5.1]
  def up
    change_column :Users, :image, :string
  end

  def down
    change_column :Users, :image, :text
  end
end

class AddPublication < ActiveRecord::Migration
  def change
    add_column :posts, :publication, :integer
    add_column :comments, :publication, :integer
    add_column :boards, :publication, :integer
  end
end
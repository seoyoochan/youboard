class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.references :user, index: true
      t.references :board, index: true
      t.boolean :allow_comment
      t.string :attachment_token
      t.timestamps
    end
  end
end

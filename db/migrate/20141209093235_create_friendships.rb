class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.integer :user_id
      t.integer :friend_id
      t.string :state
      t.datetime :accepted_at
      t.datetime :blocked_at
      t.datetime :sent_at
      t.datetime :received_at
      t.timestamps null: false
    end

      add_index :friendships, :user_id
      add_index :friendships, :friend_id
      # a user isn't allowed to be friends with the same user more than once
      add_index :friendships, [:user_id, :friend_id], unique: true 
  end
end

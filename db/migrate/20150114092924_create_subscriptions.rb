class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :user, index: true
      t.string :subscribable_type
      t.integer :subscribable_id
      t.timestamps null: false
    end
    add_foreign_key :subscriptions, :users
  end
end

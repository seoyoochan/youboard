class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.string :name
      t.integer :topic
      t.text :description
      t.references :user, index: true

      t.timestamps
    end
  end
end

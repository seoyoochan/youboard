class CreateScraps < ActiveRecord::Migration
  def change
    create_table :scraps do |t|
      t.references :post, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end

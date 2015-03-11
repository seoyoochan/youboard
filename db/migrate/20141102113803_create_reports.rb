class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.references :user, index: true
      t.integer :reportable_id
      t.string :reportable_type
      t.timestamps
    end
  end
end

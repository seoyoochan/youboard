class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.references :user, index: true
      t.references :attachable, polymorphic: true
      t.string :attachment_token
      t.timestamps null: false
    end
  end
end

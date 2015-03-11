class CreateAttachedFiles < ActiveRecord::Migration
  def change
    create_table :attached_files do |t|
      t.references :attachment, index: true
      t.string :file
      t.string :content_type
      t.integer :file_size, :limit => 5
      t.string :width
      t.string :height
      t.string :overall_content_type
      t.string :extension
      t.string :original_name
      t.timestamps null: false

      # t.integer :int                 # int (4 bytes, max 2,147,483,647)
      # t.integer :int1, :limit => 1   # tinyint (1 byte, -128 to 127)
      # t.integer :int2, :limit => 2   # smallint (2 bytes, max 32,767)
      # t.integer :int3, :limit => 3   # mediumint (3 bytes, max 8,388,607)
      # t.integer :int4, :limit => 4   # int (4 bytes)
      # t.integer :int5, :limit => 5   # bigint (8 bytes, max 9,223,372,036,854,775,807)
      # t.integer :int8, :limit => 8   # bigint (8 bytes)
      # t.integer :int11, :limit => 11 # int (4 bytes)
    end
    add_foreign_key :attached_files, :attachments
  end
end

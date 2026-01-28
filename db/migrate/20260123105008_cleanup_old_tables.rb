class CleanupOldTables < ActiveRecord::Migration[7.2]
  def change
  # Remove tables left from an old project
    drop_table :users if table_exists?(:users)
    drop_table :posts if table_exists?(:posts)
    
  # Also remove ActiveStorage tables if you don't plan to use them as-is right now
    drop_table :active_storage_variant_records if table_exists?(:active_storage_variant_records)
    drop_table :active_storage_attachments if table_exists?(:active_storage_attachments)
    drop_table :active_storage_blobs if table_exists?(:active_storage_blobs)
  end
end
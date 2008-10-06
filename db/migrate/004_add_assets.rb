class AddAssets < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.string :title
      t.string :caption
      t.string :image
      t.integer :page_id

      t.timestamps
    end
  end

  def self.down
    drop_table :assets
  end
end

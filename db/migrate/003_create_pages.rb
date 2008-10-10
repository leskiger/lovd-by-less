class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :title
      t.text :body
      t.string :link_url
      t.integer :parent_id
      t.integer :rgt
      t.integer :lft
      t.string :kind
      t.string :menu_alignment
      t.string :permalink
      t.boolean :public, :default => true

      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end

class CreateTaggings < ActiveRecord::Migration
  def self.up
    create_table :taggings do |t|
      t.references :tag, :user
      t.references :scopable, :taggable, :polymorphic => true
    end

    add_index :taggings, [:taggable_type, :taggable_id]
    add_index :taggings, [:scopable_type, :scopable_id]
  end

  def self.down
    drop_table :taggings
  end
end

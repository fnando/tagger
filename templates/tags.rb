class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :name
    end

    add_index :tags, :name
  end

  def self.down
    drop_table :tags
  end
end

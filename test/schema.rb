ActiveRecord::Schema.define(:version => 0) do
  create_table :categories do |t|
    t.string :name
  end
  
  create_table :posts do |t|
    t.references :category
    t.string :title
  end
  
  create_table :links do |t|
    t.string :title, :url
  end
  
  create_table :taggings do |t|
    t.references :tag, :user
    t.references :scopable, :taggable, :polymorphic => true
  end
  
  create_table :tags do |t|
    t.string :name
  end
end
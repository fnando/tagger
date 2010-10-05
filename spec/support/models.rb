class Link < ActiveRecord::Base
  taggable :separator => :space
end

class Post < ActiveRecord::Base
  belongs_to :category
  taggable :scope => :category
end

class Category < ActiveRecord::Base
  has_many :posts
end

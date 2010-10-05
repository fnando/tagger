class Tag < ActiveRecord::Base
  SEPARATORS = {
    :comma => ",",
    :space => " "
  }

  has_many :taggings
  attr_reader :weight

  # Tag.cloud(:post)
  # Tag.cloud(:post, :scope => @category)
  # Tag.cloud(:post, :limit => 50)
  def self.cloud(type, options = {})
    options[:limit] ||= 100

    scope_condition = "
      AND scopable_type = #{options[:scope].class.to_s.inspect}
      AND scopable_id = #{options[:scope].id}" if options[:scope]

    tags = Tag.find_by_sql [%(
      SELECT tags.id, tags.name, COUNT(*) AS total
      FROM tags, taggings
      WHERE
        tags.id == taggings.tag_id AND
        taggings.taggable_type = ?
        #{scope_condition}
      GROUP BY taggings.tag_id
      ORDER BY total DESC, name ASC
      LIMIT ?
    ), type.to_s.classify, options[:limit]]
  end

  # Tag.parse(tags_list, :comma)
  # Tag.parse(tags_list, :space)
  def self.parse(tag_list, separator)
    separator = SEPARATORS[separator] || SEPARATORS[:comma]
    tags = []
    tag_list = tag_list.dup
    tag_list.gsub!(/(["'])(.*?)(\1)/ms) {|m| tags << $2; "" }
    tags += tag_list.split(separator)
    tags.collect(&:squish).reject(&:blank?).sort_by {|tag| tag.downcase}
  end

  def total
    read_attribute(:total).to_i
  end

  def to_s
    name
  end
end
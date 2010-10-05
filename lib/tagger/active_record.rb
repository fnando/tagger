module Tagger
  module ActiveRecord
    def self.included(base)
      base.extend ClassMethods

      class << base
        attr_accessor :taggable_options
      end
    end

    module ClassMethods
      def taggable(options={})
        include InstanceMethods

        self.taggable_options = {
          :separator => options[:separator],
          :scope => options[:scope]
        }

        has_many :taggings, :as => :taggable, :dependent => :destroy
        has_many :tags, :through => :taggings, :order => "tags.name asc"

        after_save :save_tags
      end
    end

    module InstanceMethods
      def tagged_with=(tags)
        @tagged_with = joined_tags(parsed_tags(tags))
      end

      def tagged_with
        @tagged_with ||= joined_tags(tags.all.collect(&:name))
      end

      private
      # Parse a tag string using the preferred tag separator.
      #
      #   parsed_tags("a, d, c, b")
      #   #=> ["a", "b", "c", "d"]
      #
      def parsed_tags(tags)
        Tag.parse(tags, self.class.taggable_options[:separator])
      end

      # Receive an array of tags and join them using the
      # preferred tag separator.
      #
      #   joined_tags %w[b c d a]
      #   #=> a, b, c, d
      #
      def joined_tags(tags)
        tags = tags.sort_by {|tag| tag.downcase}

        if self.class.taggable_options[:separator] == :space
          tags.collect {|tag| tag.include?(" ") ? %["#{tag}"] : tag }.join(" ")
        else
          tags.join(", ")
        end
      end

      # Remove all associated tags and re-create them.
      def save_tags
        Tag.transaction do
          taggings.delete_all

          scope = nil
          scope = send(self.class.taggable_options[:scope]) if self.class.taggable_options[:scope]

          parsed_tags(tagged_with).each do |tag_name|
            tag = Tag.find_or_create_by_name(tag_name)
            self.taggings.create(:tag => tag, :scope => scope)
          end
        end
      end
    end
  end
end

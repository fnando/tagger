module SimplesIdeias
  module Acts
    module Tags
      module Helper
        # tag_cloud @tags do {|tag_name, css_class|}
        # tag_cloud @tags, %w(t1 t2 t3 t4 t5) do {|tag_name, css_class| #=> do something }
        def tag_cloud(tags, css_classes=nil, &block)
          # set css classes if not specified
          css_classes ||= %w(s1 s2 s3 s4 s5)
          
          # collect all tag totals
          totals = tags.collect(&:total)
          
          # get max and min totals
          max = totals.max.to_i
          min = totals.min.to_i
          
          divisor = ((max - min) / css_classes.size) + 1

          tags.each do |tag|
            yield tag.name, css_classes[(tag.total - min) / divisor] if divisor != 0
          end
        end
      end
      
      module Model
        def self.included(base)
          base.extend SimplesIdeias::Acts::Tags::Model::ClassMethods
        
          class << base
            attr_accessor :has_tags_options
          end
        end
      
        module ClassMethods
          def has_tags(options={})
            include SimplesIdeias::Acts::Tags::Model::InstanceMethods
          
            self.has_tags_options = {
              :type => ActiveRecord::Base.send(:class_name_of_active_record_descendant, self).to_s,
              :separator => options[:separator],
              :scope => options[:scope]
            }
          
            has_many :taggings, :as => :taggable, :dependent => :destroy
            has_many :tags, :through => :taggings, :order => "tags.name asc"
          
            after_save :save_tags
          end
        end
      
        module InstanceMethods
          def tag_separator
            Tag::SEPARATORS[self.class.has_tags_options[:separator]] || ","
          end
        
          def tagged_with=(tag_list)
            @tagged_with = tag_list
          end
        
          def tagged_with
            @tagged_with = begin
              if self.class.has_tags_options[:separator] == :space
                tags.collect do |tag| 
                  name = tag.name
                  name.include?(' ') ? name.inspect : name
                end.join(' ')
              else
                tags.collect(&:name).join(', ')
              end
            end
          end
        
          def save_tags
            Tag.transaction do
              self.taggings.delete_all
            
              scope = nil
              scope = send(self.class.has_tags_options[:scope]) if self.class.has_tags_options[:scope]
            
              Tag.parse(@tagged_with, self.class.has_tags_options[:separator]).each do |tag_name|
                tag = Tag.find_or_create_by_name(tag_name)
                self.taggings.create(:tag => tag, :scope => scope)
              end
            end
          end
        end
      end
    end
  end
end
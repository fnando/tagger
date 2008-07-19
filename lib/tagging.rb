class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :taggable, :polymorphic => true
  
  before_save :define_scope
  
  def scope=(object)
    @scope = object
  end
  
  def scope
    @scope = scopable_type.constantize.find(scopable_id) if !!scopable_id
  end
  
  private
    def define_scope
      unless @scope.blank?
        write_attribute(:scopable_type, @scope.class.to_s)
        write_attribute(:scopable_id, @scope.id)
      end
    end
end
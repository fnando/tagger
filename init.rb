require "has_tags"
ActiveRecord::Base.send(:include, SimplesIdeias::Acts::Tags::Model)
ActionView::Base.class_eval { include SimplesIdeias::Acts::Tags::Helper }

require File.dirname(__FILE__) + "/lib/tag"
require File.dirname(__FILE__) + "/lib/tagging"
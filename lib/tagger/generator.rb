require "rails/generators/base"

module Tagger
  class InstallGenerator < ::Rails::Generators::Base
    source_root File.dirname(__FILE__) + "/../../templates"

    def copy_migrations
      stamp = proc {|time| time.utc.strftime("%Y%m%d%H%M%S")}
      copy_file "tags.rb",      "db/migrate/#{stamp[Time.now]}_create_tags.rb"
      copy_file "taggings.rb",  "db/migrate/#{stamp[1.second.from_now]}_create_taggings.rb"
    end
  end
end

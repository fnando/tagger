module Tagger
  class Railtie < Rails::Railtie
    generators do
      require "tagger/generator"
    end

    initializer "tagger.initializer" do |app|
      ::ActiveRecord::Base.send :include, ActiveRecord
      ::ActionView::Base.send   :include, Helper
    end
  end
end

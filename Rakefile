require "rspec/core/rake_task"
require "./lib/tagger/version"

RSpec::Core::RakeTask.new do |t|
  t.ruby_opts = %w[-Ilib -Ispec]
end

begin
  require "jeweler"

  JEWEL = Jeweler::Tasks.new do |gem|
    gem.name = "tagger"
    gem.version = Tagger::Version::STRING
    gem.summary = "Add tagging support for Rails apps"
    gem.description = "Add tagging support for Rails apps"
    gem.authors = ["Nando Vieira"]
    gem.email = "fnando.vieira@gmail.com"
    gem.homepage = "http://github.com/fnando/tagger"
    gem.has_rdoc = false
    gem.add_dependency "rails", ">= 3.0.0"
    gem.files = FileList["{Gemfile,Gemfile.lock,Rakefile,MIT-LICENSE,tagger.gemspec,README.rdoc}", "{lib,spec,templates}/**/*"]
  end

  Jeweler::GemcutterTasks.new
rescue LoadError => e
  puts "You don't Jeweler installed, so you won't be able to build gems."
end

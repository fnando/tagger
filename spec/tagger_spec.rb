# -*- encoding: utf-8 -*-
require "spec_helper"

describe Tagger do
  fixtures :posts, :categories, :links, :tags

  before do
    @link = links(:simples_ideias)
    @category = categories(:programming)
    @post = posts(:all_about_rails)
  end

  it "should have many tags" do
    expect { @post.tags }.to_not raise_error
  end

  it "should have many taggings" do
    expect { @post.taggings }.to_not raise_error
  end

  it "should create tags" do
    @post.tagged_with = "rails, programming, howto"
    @post.save
    @post.tags.count.should == 3
  end

  it "should create tags separated by spaces" do
    @link.tagged_with = %[programming "nando vieira" blog]
    @link.save
    @link.tags.count.should == 3
  end

  it "should return joined list" do
    @post.tagged_with = "rails, programming, howto"
    @post.save
    @post.tagged_with.should == "howto, programming, rails"
  end

  it "should accept multiples words when separated by space" do
    @link.tagged_with = %["Ruby on Rails" programming howto]
    @link.save
    @link.tagged_with.should == %[howto programming "Ruby on Rails"]
  end

  it "should sort tags by name" do
    @link.tagged_with = "e f g a z"
    @link.save
    @link.tagged_with.should == "a e f g z"
  end

  it "should create tag using scope" do
    @post.tagged_with = "rails, programming"
    @post.save

    tagging = @post.taggings.first
    tagging.should_not be_nil
    tagging.scope == categories(:programming)
  end

  describe Tag do
    it "should return its name on the to_s method" do
      Tag.create(:name => "rails").to_s.should == "rails"
    end

    it "should strip empty tags when using comma" do
      Tag.parse("rails,,,,,,,,,,programming", :comma).should == %w[programming rails]
    end

    it "should strip empty tags when using space" do
      Tag.parse("rails              programming", :space).should == %w[programming rails]
    end

    it "should recognize multiple words when using comma" do
      Tag.parse("ruby on rails, web development, programming, ruby", :comma).should == ["programming", "ruby", "ruby on rails", "web development"]
    end

    it "should recognize multiple words when using space" do
      Tag.parse(%["ruby on rails"  "web development" programming ruby], :space).should == ["programming", "ruby", "ruby on rails", "web development"]
    end

    it "normalizes accented words" do
      Tag.parse("popularização", :space).should == %w[popularização]
    end
  end

  describe "Tag.cloud" do
    it "should return total as number" do
      posts(:all_about_rails).update_attribute(:tagged_with, "ruby, rails, web")
      posts(:ideas).update_attribute(:tagged_with, "ruby, rails, web")

      @tags = Tag.cloud(:post)
      @tags.first.total.should == 2
    end

    it "should return tags using scope" do
      posts(:all_about_rails).update_attribute(:tagged_with, "ruby, rails, web")
      posts(:ideas).update_attribute(:tagged_with, "ruby, rails, web")

      @tags = Tag.cloud(:post, :scope => categories(:essays))
      @tags.first.total.should == 1
    end

    it "should return limited tags" do
      @post.update_attribute(:tagged_with, "ruby, rails, programming, howto")

      @tags = Tag.cloud(:post, :limit => 2)
      @tags.size.should == 2
      @tags.first.name == "howto"
      @tags.last.name == "rails"
    end
  end

  describe Tagging do
    it "should set scope" do
      tagging = create_tagging(:scope => categories(:programming))
      tagging.scope.should == categories(:programming)
      tagging.scopable_type == "Category"
      tagging.scopable_id == categories(:programming).id
    end
  end

  private
  def create_tagging(options={})
    Tagging.create({
      :tag => tags(:ruby),
      :scope => categories(:programming),
      :taggable => posts(:all_about_rails)
    }.merge(options))
  end
end
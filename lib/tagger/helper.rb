module Tagger
  module Helper
    # Build a tag cloud based on the provided tags.
    #
    #   tag_cloud @tags do {|tag_name, css_class|}
    #   tag_cloud @tags, %w(t1 t2 t3 t4 t5) do {|tag_name, css_class| #=> do something }
    #
    def tag_cloud(tags, css_classes = nil, &block)
      # set css classes if not specified
      css_classes ||= %w[s1 s2 s3 s4 s5]

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
end

# encoding: utf-8

module MapnikLegendary
  # convenience methods for handling tags
  class Tags
    # Merges a list of extra keys into an existing hash of tags.
    # The extra keys are each given a null value.
    def self.merge_nulls(tags, extras)
      tags = {} if tags.nil?
      extras = [] if extras.nil?
      Hash[extras.map { |t| [t, nil] }].merge(tags)
    end
  end
end

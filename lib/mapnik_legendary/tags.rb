# encoding: utf-8

module MapnikLegendary
  class Tags
    def self.merge_nulls(tags, extras)
      extras = [] if extras.nil?
      Hash[extras.map { |t| [t, 'null'] }].merge(tags)
    end
  end
end

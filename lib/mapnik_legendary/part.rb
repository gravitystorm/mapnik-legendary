# encoding: utf-8

require 'mapnik_legendary/tags'
require 'mapnik_legendary/geometry'

module MapnikLegendary

  # A part is a combination of tags, geometry and layers.
  class Part
    attr_reader :tags, :geom, :layers

    def initialize(h, zoom, map, extra_tags)
      @tags = Tags.merge_nulls(h['tags'], extra_tags)
      @geom = Geometry.new(h['type'], zoom, map)
      if h['layer']
        @layers = [ h['layer'] ]
      else
        @layers = h['layers']
      end
    end

    def to_csv
      csv = ''
      csv << @tags.keys.push('wkt').join(',') + "\n"
      csv << @tags.values.push(@geom.to_csv).join(',') + "\n"
    end
  end
end

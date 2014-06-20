# encoding: utf-8

require 'mapnik_legendary/part'

module MapnikLegendary

  # A feature has a name, description, and one or more parts holding geometries, tags and layers
  class Feature
    attr_reader :name, :parts

    def initialize(feature, zoom, map, extra_tags)
      @name = feature['name']
      @parts = []
      if feature.has_key? 'parts'
        feature['parts'].each do |part|
          @parts << Part.new(part, zoom, map, extra_tags)
        end
      else
        @parts << Part.new(feature, zoom, map, extra_tags)
      end
    end

    def envelope
      @parts.first.geom.envelope
    end
  end
end
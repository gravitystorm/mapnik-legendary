require 'pry'

module MapnikLegendary
  class Geometry
    def initialize(type, zoom, map)
      zoom = 17 if zoom.nil?

      proj = Mapnik::Projection.new(map.srs)
      width_of_world_in_pixels = 2 ** zoom * 256
      width_of_world_in_metres = proj.forward(Mapnik::Coord2d.new(180,0)).x - proj.forward(Mapnik::Coord2d.new(-180,0)).x
      width_of_image_in_metres = map.width.to_f / width_of_world_in_pixels * width_of_world_in_metres
      height_of_image_in_metres = map.height.to_f / width_of_world_in_pixels * width_of_world_in_metres

      max_x = width_of_image_in_metres
      max_y = height_of_image_in_metres
      min_x = 0
      min_y = 0

      @geom = case type
              when "point" then "POINT(#{max_x/2} #{max_y/2})"
              when "polygon" then "POLYGON((0 0, #{max_x} 0, #{max_x} #{max_y}, 0 #{max_y}, 0 0))"
              else "LINESTRING(0 0, #{max_x} #{max_y})"
              end

      map.zoom_to_box(Mapnik::Envelope.new(min_x,min_y,max_x,max_y))
    end

    def to_csv
      %Q{"#{@geom}"}
    end
  end
end

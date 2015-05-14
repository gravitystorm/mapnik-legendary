# encoding: utf-8

module MapnikLegendary
  class Geometry
    def initialize(type, zoom, map)
      proj = Mapnik::Projection.new(map.srs)
      width_of_world_in_pixels = 2**zoom * 256
      width_of_world_in_metres = proj.forward(Mapnik::Coord2d.new(180, 0)).x - proj.forward(Mapnik::Coord2d.new(-180, 0)).x
      width_of_image_in_metres = map.width.to_f / width_of_world_in_pixels * width_of_world_in_metres
      height_of_image_in_metres = map.height.to_f / width_of_world_in_pixels * width_of_world_in_metres

      @max_x = width_of_image_in_metres
      @max_y = height_of_image_in_metres
      @min_x = 0
      @min_y = 0

      @geom = case type
              when 'point' then "POINT(#{@max_x / 2} #{@max_y / 2})"
              when 'point75' then "POINT(#{@max_x * 0.5} #{@max_y * 0.75})"
              when 'polygon' then "POLYGON((0 0, #{@max_x} 0, #{@max_x} #{@max_y}, 0 #{@max_y}, 0 0))"
              when 'linestring-with-gap' then "MULTILINESTRING((0 0, #{@max_x * 0.45} #{@max_y * 0.45}),(#{@max_x * 0.55} #{@max_y * 0.55},#{@max_x} #{@max_y}))"
              when 'polygon-with-hole' then "POLYGON((#{0.7 * @max_x} #{0.2 * @max_y}, #{0.9 * @max_x} #{0.9 * @max_y}" +
                                            ", #{0.3 * @max_x} #{0.8 * @max_y}, #{0.2 * @max_x} #{0.4 * @max_y}" +
                                            ", #{0.7 * @max_y} #{0.2 * @max_y}),( #{0.4 * @max_x} #{0.6 * @max_y}" +
                                            ", #{0.7 * @max_x} #{0.7 * @max_y}, #{0.6 * @max_x} #{0.4 * @max_y}" +
                                            ", #{0.4 * @max_x} #{0.6 * @max_y}))"
              else "LINESTRING(0 0, #{@max_x} #{@max_y})"
              end
    end

    def to_csv
      %("#{@geom}")
    end

    def envelope
      Mapnik::Envelope.new(@min_x, @min_y, @max_x, @max_y)
    end
  end
end

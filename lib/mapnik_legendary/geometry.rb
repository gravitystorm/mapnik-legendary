module MapnikLegendary
  class Geometry
    def initialize(type)
      @geom = case type
              when "point" then "POINT(0.5 0.5)"
              else "LINESTRING(0 0, 1 1)"
              end
    end

    def to_csv
      %Q{"#{@geom}"}
    end
  end
end

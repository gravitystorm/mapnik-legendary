require 'mapnik'
require 'json'

require 'mapnik_legendary/geometry'

module MapnikLegendary
  def self.generate_legend(legend_file, map_file, options)

    legend = JSON.parse(File.read(legend_file))

    map = Mapnik::Map.from_xml(File.read(map_file), false, File.dirname(map_file))
    map.width = legend["width"]
    map.height = legend["height"]
    map.srs = "+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0.0 +k=1.0 +units=m +nadgrids=@null +wktext +no_defs +over"

    if legend.has_key?("background")
      map.background = Mapnik::Color.new(legend["background"])
    end

    layer_styles = {}
    map.layers.each do |l|
      layer_styles[l.name] = l.styles.map{|s| s} # get them out of the collection
    end

    legend["features"].each_with_index do |feature,idx|

      # TODO - use a proper csv library rather than .join(",") !
      geom = Geometry.new(feature["type"], feature["zoom"], map).to_csv
      header = feature["tags"].keys.push("wkt").join(",")
      row = feature["tags"].values.push(geom).join(",")
      datasource = Mapnik::Datasource.create(:type => 'csv', :inline => header + "\n" + row )

      map.layers.clear

      feature["layers"].each do |layer_name|
        l = Mapnik::Layer.new(layer_name, map.srs)
        l.datasource = datasource
        layer_styles[layer_name].each do |style_name|
          l.styles << style_name
        end
        map.layers << l
      end

      #map.zoom_to_box(Mapnik::Envelope.new(0,0,1,1))
      map.render_to_file("legend#{idx}.png", "png256:t=2")
    end
  end
end

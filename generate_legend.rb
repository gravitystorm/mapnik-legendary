#!/usr/bin/ruby

require 'mapnik'
require 'optparse'
require 'json'

options = {}
optparse = OptionParser.new do |opts|
  opts.banner = "Usage: generate_legend.rb [options] <legend_filename> <stylesheet_filename>"

  opts.on_tail('-h', '--help', "Show this message") do
    puts opts
    exit
  end
end
optparse.parse!

# Check required conditions
if (ARGV.length != 2)
  optparse.abort("Error: Two input filenames required")
  exit(-1)
end

legend_file = ARGV[0]
map_file = ARGV[1]

legend = JSON.parse(File.read(legend_file))

geom = "LINESTRING(0 0, 1 1)"

map = Mapnik::Map.from_xml(File.read(map_file), false, File.dirname(map_file))
map.width = legend["width"]
map.height = legend["height"]

if legend.has_key?("background")
  map.background = Mapnik::Color.new(legend["background"])
end

layer_styles = {}
map.layers.each do |l|
  layer_styles[l.name] = l.styles.map{|s| s} # get them out of the collection
end

legend["features"].each_with_index do |feature,idx|

  # TODO - use a proper csv library rather than .join(",") !
  quoted_geom = %Q{"#{geom}"}
  header = feature["tags"].keys.push("wkt").join(",")
  row = feature["tags"].values.push(quoted_geom).join(",")
  datasource = Mapnik::Datasource.create(:type => 'csv', :inline => header + "\n" + row )

  map.layers.clear

  feature["layers"].each do |layer_name|
    l = Mapnik::Layer.new(layer_name, "+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0.0 +k=1.0 +units=m +nadgrids=@null +wktext +no_defs +over")
    l.datasource = datasource
    layer_styles[layer_name].each do |style_name|
      l.styles << style_name
    end
    map.layers << l
    map.zoom_to_box(l.envelope)
  end

  map.render_to_file("legend#{idx}.png", "png256:t=2")
end

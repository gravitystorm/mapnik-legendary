# encoding: utf-8

require 'mapnik'
require 'yaml'
require 'fileutils'
require 'logger'

require 'mapnik_legendary/feature'
require 'mapnik_legendary/docwriter'

module MapnikLegendary
  DEFAULT_ZOOM = 17

  def self.generate_legend(legend_file, map_file, options)
    log = Logger.new(STDERR)

    legend = YAML.load(File.read(legend_file))

    if legend.key?('fonts_dir')
      Mapnik::FontEngine.register_fonts(legend['fonts_dir'])
    end

    map = Mapnik::Map.from_xml(File.read(map_file), false, File.dirname(map_file))
    map.width = legend['width']
    map.height = legend['height']
    map.srs = '+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0.0 +k=1.0 +units=m +nadgrids=@null +wktext +no_defs +over'

    if legend.key?('background')
      map.background = Mapnik::Color.new(legend['background'])
    end

    layer_styles = {}
    map.layers.each do |l|
      layer_styles[l.name] = l.styles.map { |s| s } # get them out of the collection
    end

    docs = Docwriter.new

    legend['features'].each_with_index do |feature, idx|
      # TODO: use a proper csv library rather than .join(",") !
      zoom = options.zoom || feature['zoom'] || DEFAULT_ZOOM
      feature = Feature.new(feature, zoom, map, legend['extra_tags'])
      map.zoom_to_box(feature.envelope)
      map.layers.clear

      feature.parts.each do |part|
        if part.layers.nil?
          log.warn "Can't find any layers defined for a part of #{feature.name}"
          next
        end
        part.layers.each do |layer_name|
          l = Mapnik::Layer.new(layer_name, map.srs)
          datasource = Mapnik::Datasource.create(type: 'csv', inline: part.to_csv)
          l.datasource = datasource
          unless layer_styles[layer_name]
            log.warn "Can't find #{layer_name} in the xml file"
            next
          end
          layer_styles[layer_name].each do |style_name|
            l.styles << style_name
          end
          map.layers << l
        end
      end

      FileUtils.mkdir_p('output')
      # map.zoom_to_box(Mapnik::Envelope.new(0,0,1,1))
      id = feature.name || "legend-#{idx}"
      filename = File.join(Dir.pwd, 'output', "#{id}-#{zoom}.png")
      i = 0
      while File.exist?(filename) && !options.overwrite
        i += 1
        filename = File.join(Dir.pwd, 'output', "#{id}-#{zoom}-#{i}.png")
      end
      map.render_to_file(filename, 'png256:t=2')
      docs.add File.basename(filename), feature.description
    end

    f = File.open(File.join(Dir.pwd, 'output', 'docs.html'), 'w')
    f.write(docs.to_html)
    f.close

    title = legend.key?('title') ? legend['title'] : 'Legend'
    docs.to_pdf(File.join(Dir.pwd, 'output', 'legend.pdf'), title)
  end
end

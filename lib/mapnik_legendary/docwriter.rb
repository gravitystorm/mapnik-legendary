# encoding: utf-8
require 'prawn/table'
require 'prawn'

module MapnikLegendary
  class Docwriter
    attr_accessor :image_width

    def initialize
      @entries = []
      @image_width = 100
    end

    def add(image, description)
      @entries << [image, description]
    end

    def to_html
      doc = '<html><head></head><body><table>' + "\n"
      @entries.each do |entry|
        doc += "<tr><td><img src=\"#{entry[0]}\"></td><td>#{entry[1]}</td></tr>\n"
      end
      doc += '</table></body></html>' + "\n"
      doc
    end

    def to_pdf(filename, title)
      entries = @entries
      image_width = @image_width
      Prawn::Document.generate(filename, page_size: 'A4') do
        font_families.update(
          'Ubuntu' => { bold: '/usr/share/fonts/truetype/ubuntu-font-family/Ubuntu-B.ttf',
                        italic: '/usr/share/fonts/truetype/ubuntu-font-family/Ubuntu-RI.ttf',
                        normal: '/usr/share/fonts/truetype/ubuntu-font-family/Ubuntu-R.ttf' }
        )
        font 'Ubuntu'
        font_size 12
        text title, style: :bold, size: 24, align: :center
        move_down(40)
        data = []
        image_scale = 0.5
        entries.each do |entry|
          data << { image: File.join(File.dirname(filename), entry[0]),
                    scale: image_scale,
                    position: :center,
                    vposition: :center }
          data << entry[1]
        end

        columns = image_width >= 200 ? 2 : 3

        table(data.each_slice(columns * 2).to_a, cell_style: { border_width: 0.1 }) do
          (0..columns - 1).each do |n|
            column(n * 2).width = image_width * image_scale
          end
        end
      end
    end
  end
end

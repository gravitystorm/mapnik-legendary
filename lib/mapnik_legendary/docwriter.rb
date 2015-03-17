# encoding: utf-8
require 'prawn/table'
require 'prawn'

module MapnikLegendary
  class Docwriter
    def initialize
      @entries = []
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
        data = Array.new
        entries.each do |entry|
          data << { image: File.join(File.dirname(filename), entry[0]),
                    scale: 0.5,
                    position: :center,
                    vposition: :center }
          data << entry[1]
        end
        table(data.each_slice(6).to_a, cell_style: { border_width: 0.1 })
      end
    end
  end
end

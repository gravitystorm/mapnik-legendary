# encoding: utf-8

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
  end
end

# Mapnik Legendary

[Mapnik Legendary](https://github.com/gravitystorm/mapnik-legendary) is a small utility to help with generating legends (aka map keys) from Mapnik stylesheets. You describe in a config file which attributes, and which zoom level(s) you want an image for, and it reads the stylesheet and spits out .png files. It uses the ruby-mapnik bindings to load the stylesheets and mess around with the datasources, so you don't actually need any of the shapefiles or database connections to make this work.

## Requirements

* [Ruby-Mapnik bindings](https://github.com/mapnik/Ruby-Mapnik) >= 0.2.0
* mapnik 2.x and ruby (both required for Ruby-Mapnik)

## Installation

You can install the gem from rubygems:

`gem install mapnik_legendary`

Alternatively, you can add the gem to your project's Gemfile

`gem mapnik_legendary`

## Running

For full options, run

`mapnik_legendary -h`

## Examples

`mapnik_legendary examples/openstreetmap-carto-legend.yml osm-carto.xml`

See [examples/openstreetmap-carto-legend.yml](examples/openstreetmap-carto-legend.yml)

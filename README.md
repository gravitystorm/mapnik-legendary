# Mapnik Legendary

[Mapnik Legendary](https://github.com/gravitystorm/mapnik-legendary) is a small utility to help with generating legends (aka map keys) from Mapnik stylesheets. You describe in a config file which attributes, and which zoom level(s) you want an image for, and it reads the stylesheet and spits out .png files. It uses the ruby-mapnik bindings to load the stylesheets and mess around with the datasources, so you don't actually need any of the shapefiles or database connections to make this work.

## Requirements

* [Ruby-Mapnik bindings](https://github.com/mapnik/Ruby-Mapnik)
* mapnik 2.x and ruby (both required for Ruby-Mapnik)

Fair warning - you need a patched version of Ruby-Mapnik. See [#36](https://github.com/mapnik/Ruby-Mapnik/pull/36)

## Installation

`git clone https://github.com/gravitystorm/mapnik-legendary`

That's all so far.

## Running

`./generate_legend.rb config.json`

For full options, run

`./generate_legend.rb -h`

(spoiler alert - `-h` is the only option :-) )

## Example config

See [examples/openstreetmap-carto-legend.json](examples/openstreetmap-carto-legend.json)

## Future

* Change config file from .json to .yml (for comments)
* More preset geometries (points, polygons, dual carriageways etc)

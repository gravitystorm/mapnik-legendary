# Mapnik Legendary

[Mapnik Legendary](https://github.com/gravitystorm/mapnik-legendary) is a small utility to help with generating legends (aka map keys) from Mapnik stylesheets. You describe in a config file which attributes, and which zoom level(s) you want an image for, and it reads the stylesheet and spits out .png files. It uses the ruby-mapnik bindings to load the stylesheets and mess around with the datasources, so you don't actually need any of the shapefiles or database connections to make this work.

## Requirements

* [Ruby-Mapnik bindings](https://github.com/mapnik/Ruby-Mapnik)
* mapnik 2.x and ruby (both required for Ruby-Mapnik)

Please note that you need to install the master version of Ruby-Mapnik. The latest release, 0.1.3, is insufficient.

## Installation

In the future (i.e. when there's been a new release of Ruby-Mapnik) you'll be able to use rubygems. Until then:

`git clone https://github.com/gravitystorm/mapnik-legendary`

If you want to install the gem locally, run

```
gem build mapnik_legendary.gemspec
gem install mapnik_legendary-0.x.x.gem
```

## Running

To run locally, without installing a gem, run:

`ruby -Ilib bin/mapnik_legendary`

If you've installed the gem, `mapnik_legendary` will be in your path.

For full options, run

`mapnik_legendary -h`

## Examples

`mapnik_legendary examples/openstreetmap-carto-legend.yml osm-carto.xml`

See [examples/openstreetmap-carto-legend.yml](examples/openstreetmap-carto-legend.yml)

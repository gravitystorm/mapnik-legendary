require File.expand_path('../lib/mapnik_legendary/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'mapnik_legendary'
  s.version = MapnikLegendary::VERSION
  s.author = 'Andy Allan'
  s.email = 'andy@gravitystorm.co.uk'
  s.homepage = 'https://github.com/gravitystorm/mapnik-legendary'
  s.summary = 'Create legends (map keys) for mapnik stylesheets'
  s.description = 'Creating legends by hand is tedious. This software allows you to generate them automatically.'
  s.default_executable = 'bin/mapnik_legendary'
  s.files = Dir['{lib}/**/*.rb', 'bin/*', '*.md']
  s.license = 'MIT'

  s.add_runtime_dependency 'mapnik', ['>= 0.2.0']
  s.add_runtime_dependency 'prawn'
  s.add_runtime_dependency 'prawn-table'
  s.add_development_dependency 'rspec'
end

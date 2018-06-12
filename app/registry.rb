# frozen_string_literal: true

export(:logger) do
  require 'simple-logger'
  SimpleLogger::Logger.new(STDOUT, auto_flush: true)
end

export(:Interfacer) { import('Interfacer').Interfacer }

export(:empty_router) { import('router').new }

export(:router) do
  exports.empty_router.tap { Kernel.load('app/routes.rb') }
end

export(:Route) { import('route') }
export(:ApplicationRoute) { import('application_route') }

export(:json_encoder) { import('adapters/json_encoder') }

export(:db) do
  require 'pg'; PG.connect(dbname: 'blog')
end

export(:data_store) { import('adapters/pg_store') }

# object_dir = File.expand_path('../objects', __FILE__)
# __FILE__ returns 'registry'. What the hell?
object_dir = File.expand_path('app/objects')
Dir.glob("#{object_dir}/*.rb").each do |path|
  object_path = path.sub("#{Dir.pwd}/", '')
  object_name = path.sub(/^.+\/(.)(.+)\.rb$/) { "#{Regexp.last_match(1).upcase}#{Regexp.last_match(2)}" }
  export(object_name.to_sym) { import(object_path) }
end

repository_dir = File.expand_path('app/repositories')
Dir.glob("#{repository_dir}/*.rb").each do |path|
  repository_path = path.sub("#{Dir.pwd}/", '')
  repository_name = "#{path.match(/^.+\/(.+)\.rb$/)[1]}_repository"
  export(repository_name.to_sym) { import(repository_path) }
end

# Mixins.
export(:Rendering) { import('mixins/rendering') }

# Rack.
export(:RackRouterApp) { import('rack/router').new }
export(:RackApp) { import('rack/app') }

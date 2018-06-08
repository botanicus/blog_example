export(:logger) do
  require 'logger'
  Logger.new(STDOUT)
end

export(:Interfacer) do
  import('Interfacer').Interfacer
end

export(:router) do
  import('router').new
end

export(:json_encoder) do
  import('adapters/json_encoder')
end

# Mixins.
export(:Rendering) do
  import('mixins/rendering')
end

# Rack.
export(:RackRouterApp) do
  import('rack/router').new
end

export(:RackApp) do
  import('rack/app')
end

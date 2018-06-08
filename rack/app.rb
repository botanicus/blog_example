registry = import('registry')

export do
  Rack::Builder.new do
    # use Rack::Etag
    use Rack::ConditionalGet  # Support Caching
    # use Rack::Deflator        # GZip
    use Rack::ContentLength
    use Rack::Head
    run registry.RackRouterApp
  end
end

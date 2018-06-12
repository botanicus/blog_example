# frozen_string_literal: true

registry = import('registry')

export do
  Rack::Builder.new do
    use Rack::ETag
    use Rack::ConditionalGet  # Support Caching
    use Rack::Deflater        # GZip
    use Rack::ContentLength
    use Rack::ContentType, 'application/json'
    use Rack::Head
    use Rack::CommonLogger, registry.logger

    run registry.RackRouterApp
  end
end

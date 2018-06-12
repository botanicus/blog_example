# frozen_string_literal: true

logger, router = import('registry').grab(:logger, :empty_router)

router.register_default(import('routes/errors/404'))
router.register_error_route(import('routes/errors/500'))

route_dir = File.expand_path('routes', __dir__)
Dir.glob("#{route_dir}/*.rb").each do |path|
  logger.debug("Registering routes from #{path.sub("#{Dir.pwd}/", '')}.")
  exported_route = import(path)
  if exported_route.respond_to?(:_DATA_)
    exported_route._DATA_.keys.each do |name|
      router.register(exported_route.send(name))
    end
  else
    router.register(import(path))
  end
end

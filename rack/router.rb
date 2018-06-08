Interfacer, logger, router = import('registry').grab(:Interfacer, :logger, :router)

# Register routes.
router.register_default(import('routes/errors/404'))
router.register_error_route(import('routes/errors/500'))

route_dir = File.expand_path('../../routes', __FILE__)
Dir.glob("#{route_dir}/*.rb").each do |path|
  router.register(import(path))
end

RouterApp = Class.new do
  extend Interfacer

  attribute(:logger, :debug, :info) { logger }
  attribute(:router, :route) { router }
  
  def call(env)
    route_class = router.route(env)
    route = route_class.new
    logger.debug("~ #{env['REQUEST_METHOD']} #{env['PATH_INFO']} -> #{route_class.name}")
    route.call(env)
  rescue => error
    logger.fatal("~ #{error.class} #{error.message}\n#{error.backtrace.join("\n- ")}")
    
    unless router.error_route
      raise "Error route not set."
    end

    route = router.error_route.new
    route.call(env, error)
  end
end

export { RouterApp }

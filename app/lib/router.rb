# frozen_string_literal: true

Interfacer, logger = import('registry').grab(:Interfacer, :logger)

Router = Class.new do
  extend Interfacer

  attribute(:logger, :debug, :info) { logger }

  def route_list
    @route_list ||= Array.new
  end

  def route(env)
    self.find(env) || @default_route || raise("Nothing found.")
  end

  # @api private
  def find(env)
    self.route_list.find do |route_class|
      unless route_class.respond_to?(:match)
        raise "Route #{route_class} has to have .match method!"
      end

      unless route_class.method(:match).parameters.length == 1
        raise "Method #{route_class}.match has to take env as its only argument!"
      end

      route_class.match(env)
    end
  end

  def register(route_class)
    self.route_list << route_class
  end

  def register_default(route_class)
    @default_route = route_class
  end

  attr_reader :error_route
  def register_error_route(route_class)
    @error_route = route_class
  end

  def handle(env)
    route_class = self.route(env)
    route_class.call(env)
  rescue => error
    logger.fatal("#{error.class} #{error.message}\n#{error.backtrace.join("\n- ")}")

    unless self.error_route
      raise "Error route not set."
    end

    self.error_route.call(env, error)
  end
end

export { Router }

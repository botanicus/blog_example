# frozen_string_literal: true

Interfacer, logger = import('registry').grab(:Interfacer, :logger)

class Matcher
  def initialize(http_method, route_pattern)
    @http_method, @route_pattern = http_method, route_pattern
  end

  def route_regexp
    pattern = @route_pattern.gsub(/\/:([^\/]+)/, '/(?<\1>[^/]+)')
    Regexp.new("^#{pattern}/?$")
  end

  def matches?(env)
    @http_method == env['REQUEST_METHOD'] && env['PATH_INFO'].match(self.route_regexp)
  end
end

module Routing
  def route_matchers
    @route_matchers ||= Array.new
  end

  [:get, :post, :put, :patch, :delete].each do |method_name|
    define_method(method_name) do |route_pattern|
      self.route_matchers << Matcher.new(method_name.to_s.upcase, route_pattern)
    end
  end

  def match(env)
    self.route_matchers.find do |matcher|
      matcher.matches?(env)
    end
  end
end

Route = Class.new do
  extend Routing

  extend Interfacer
  attribute(:logger) { logger } # <- We are in a closure, we can get rid of this. (But then no DI(?))

  # By using closures we can access logger.
  define_singleton_method(:call) do |env, *args|
    route = self.new(env)
    logger.debug("#{env['REQUEST_METHOD']} #{env['PATH_INFO']} -> #{route.class}")

    matched_matcher = self.route_matchers.find do |matcher|
      matcher.matches?(env)
    end

    return_value = if matched_matcher
      match = env['PATH_INFO'].match(matched_matcher.route_regexp)
      params = match.named_captures.transform_keys(&:to_sym)

      logger.debug("Dispatching to #{route.class}#call with #{params.inspect}.")
      route.call(*args, **params)
    else
      route.call(*args)
    end

    return_value = [200, Hash.new, [return_value]] if return_value.is_a?(String)

    logger.debug("Rendering HTTP #{return_value[0]} -> #{return_value[2].join(', ')}")

    return_value
  end

  def request_data
    # TODO: Use DI.
    @request_data ||= JSON.parse(env['rack.input'].read, symbolize_names: true)
  end

  attr_reader :env
  def initialize(env)
    @env = env
  end

  def call(*args)
    raise NotImplementedError, "Override in subclasses."
  end
end

export { Route }

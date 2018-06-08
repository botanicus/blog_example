Rendering = import('registry').Rendering

class RootRoute
  include Rendering

  def self.match(env)
    env['PATH_INFO'] == '/'
  end

  def call(env)
    render message: 'Hello world!'
  end
end

export { RootRoute }

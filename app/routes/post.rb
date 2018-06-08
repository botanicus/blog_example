Rendering = import('registry').Rendering

class PostRoute
  include Rendering

  def self.match(env)
    env['PATH_INFO'] == '/'
  end

  def call(env)
    # TODO
  end
end

export { PostRoute }

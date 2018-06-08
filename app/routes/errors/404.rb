Rendering = import('registry').Rendering

class NotFoundRoute
  include Rendering

  def call(env)
    render({error: "Not found anything for #{env['PATH_INFO']}!"}, {status_code: 404})
  end
end

export { NotFoundRoute }

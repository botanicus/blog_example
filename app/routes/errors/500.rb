Rendering = import('registry').Rendering

class InternalServerErrorRoute
  include Rendering

  def call(env, error)
    render({error: "Error #{error.class}!"}, {status_code: 500})
  end
end

export { InternalServerErrorRoute }

Route, Rendering = import('registry').grab(:Route, :Rendering)

class NotFoundRoute < Route
  include Rendering

  def call
    render 404, error: "Not found anything for #{env['PATH_INFO']}!"
  end
end

export { NotFoundRoute }

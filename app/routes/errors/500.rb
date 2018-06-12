# frozen_string_literal: true

Route, Rendering = import('registry').grab(:Route, :Rendering)

class InternalServerErrorRoute < Route
  include Rendering

  def call(error)
    render 500, error: "Error #{error.class}!"
  end
end

export { InternalServerErrorRoute }

# frozen_string_literal: true

Route, Rendering = import('registry').grab(:Route, :Rendering)

class RootRoute < Route
  include Rendering

  get '/'

  def call
    render message: 'Hello world!'
  end
end

export { RootRoute }

# frozen_string_literal: true

Interfacer, router = import('registry').grab(:Interfacer, :router)

RouterApp = Class.new do
  extend Interfacer

  attribute(:router, :handle) { router }

  def call(env)
    router.handle(env)
  end
end

export { RouterApp }

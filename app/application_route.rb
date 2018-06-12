# frozen_string_literal: true

Interfacer, Route, store = import('registry').
  grab(:Interfacer, :Route, :data_store)

# TODO: Composition instead of inheritance?
ApplicationRoute = Class.new(Route) do
  extend Interfacer
  attribute(:store, :retrieve) { store }
end

export { ApplicationRoute }

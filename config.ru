#!/usr/bin/env ruby -Iapp -Iapp/lib -rbundler/setup -S rackup -E none
# frozen_string_literal: true

# -E none is to remove the default middleware stack such as Rack::ShowExceptions.

require 'import'
registry = import('registry')

run registry.RackApp

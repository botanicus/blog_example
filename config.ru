#!/usr/bin/env ruby -Iapp -Iapp/lib -rbundler/setup -S rackup

require 'import'
registry = import('registry')

run registry.RackApp

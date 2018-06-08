#!/usr/bin/env ruby -Ilib -rbundler/setup -S rackup

require 'import'
registry = import('registry')

run registry.RackApp

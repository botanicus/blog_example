# frozen_string_literal: true

require 'json'

# To get going, we can just do `export { JSON }` and be done with it.

# It's better not to proxy all the arguments, but be specific.
# Otherwise we risk using API that we don't describe in this definition.
def exports.parse(text)
  JSON.parse(text)
end

# So for instance here, we don't proxy all the arguments as then we might
# forget and start using say `generate(object, indent: '  ')` which another
# adapter most likely wouldn't support.
def exports.generate(object)
  JSON.generate(object)
end

export name: JSON.name

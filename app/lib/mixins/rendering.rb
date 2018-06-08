Interfacer, json_encoder = import('registry').grab(:Interfacer, :json_encoder)

Rendering = Module.new do
  extend Interfacer

  attribute(:json_encoder, :generate) { json_encoder }

  def render(status_code, content = '')
    if content.is_a?(String)
      [status_code, Hash.new, [content]]
    else
      encoded_data = json_encoder.generate(content)
      [status_code, Hash.new, [encoded_data]]
    end
  end
end

export { Rendering }

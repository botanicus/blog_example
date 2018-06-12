# frozen_string_literal: true

class Post
  attr_reader :data
  def initialize(id: nil, title:, body:)# , author:, tags: Array.new)
    @data = {id: id, title: title, body: body}# , author: author, tags: tags}
  end

  def reload(id: nil, title:, body:)
    @data = {id: id, title: title, body: body}# , author: author, tags: tags}
  end
end

export { Post }

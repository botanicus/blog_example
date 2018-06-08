class Post
  attr_reader :data
  def initialize(id: nil, title:, body:)#, author:, tags: Array.new)
    @data = {title: title, body: body}#, author: author, tags: tags}
  end
end

export { Post }

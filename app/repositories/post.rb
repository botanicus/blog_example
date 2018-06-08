Interfacer, data_store, Post = import('registry').grab(:Interfacer, :data_store, :Post)

# Can I use actors and defer when doing pg.exec OR use pg.async_exec
PostRepository = Class.new do
  extend Interfacer

  attribute(:data_store, :store) { data_store }

  # Rename.
  attribute :title, :string
  attribute :body, :text
  # attribute :author, :string # TODO
  # attribute :tags, :array

  def retrieve(id)
    data = self.data_store.retrieve('posts', id)
    data = data.transform_keys(&:to_sym)
    Post.new(**data)
  end

  def store(post)
    self.data_store.store(post.data)
  end
end

registry.data_store.create_table(:posts, id: 'serial', title: 'varchar(256)', body: 'text')
registry.data_store.insert(:posts, title: "Hello world!", body: "...")
registry.data_store.insert(:posts, title: "Second post", body: "...")

export { PostRepository }

# TODO: raise NotFoundError if PG::NotFound
ApplicationRoute, Rendering, Post = import('registry').grab(:ApplicationRoute, :Rendering, :Post)

# GET /posts/:id
class PostRoute < ApplicationRoute
  # Shorter syntax. We can still implement the match method directly.
  get '/posts/:id'

  # Here we don't need to instantiate Post. DB -> JSON.
  def call(id:)
    store.retrieve_json(:posts, id)
  end
end

# GET /posts
class PostIndexRoute < ApplicationRoute
  get '/posts'

  def call
    store.retrieve_all_json(:posts)
  end
end

# POST /posts
class PostCreateRoute < ApplicationRoute
  include Rendering

  post '/posts'

  def call
    post = Post.new(**request_data)
    data = store.insert(:posts, post.data)
    post.reload(**data)
    render 201, post.data # Without ID this way.
  rescue ArgumentError => error
    render 400, error: error.message
  end
end

# DELETE /posts/:id
class PostDeleteRoute < ApplicationRoute
  include Rendering

  delete '/posts/:id'

  def call(id:)
    store.delete(:posts, id)
    render 204
  end
end

# PUT /posts/:id
class PostUpdateRoute < ApplicationRoute
  include Rendering

  put '/posts/:id'

  def call(id:)
    post = Post.new(**request_data)
    data = store.update(:posts, id, post.data)
    render data
  rescue ArgumentError => error
    render 400, error: error.message
  end
end

# PATCH /posts/:id
class PostPatchRoute < ApplicationRoute
  include Rendering

  patch '/posts/:id'

  def call(id:)
    data = store.retrieve(:posts, id)
    post = Post.new(data.merge(request_data))
    data = store.update(:posts, id, post.data)
    render data
  rescue ArgumentError => error
    render 400, error: error.message
  end
end

export PostRoute, PostIndexRoute, PostCreateRoute,
       PostDeleteRoute, PostUpdateRoute, PostPatchRoute

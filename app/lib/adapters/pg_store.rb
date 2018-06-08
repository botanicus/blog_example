# TODO: Rename: this is not a generic data_store, this should be an adapter.

# Examples:
# SQL table_name -> id
#
# Directory with YAML files.
# data/posts.yml -> A list.
#
# Nested directories with YAML files.
# data/posts/1.yml
DB = import('registry').db

# TODO: Now you composition to avoid having to specify table_name
# @tableName('posts')
def exports.retrieve(table_name, id)
  result = DB.exec("SELECT * from #{table_name} WHERE id=#{id}")
  result.each.to_a[0].transform_keys(&:to_sym)
end

def exports.retrieve_json(table_name, id)
  result = DB.exec("SELECT row_to_json(#{table_name}) from posts WHERE id=#{id}")
  result.values[0][0]
end

def exports.retrieve_all_json(table_name)
  result = DB.exec("SELECT array_to_json(array_agg(row_to_json(#{table_name}))) from posts")
  result.values[0][0]
end

def exports.store(table_name, data)
  if id = data[:id]
    exports.update(table_name, id, data.except(:id))
  else
    exports.insert(table_name, data)
  end
end

def exports.insert(table_name, data)
  values = data.values.map { |value| "'#{value}'" }
  result = DB.exec("INSERT into #{table_name} (#{data.keys.join(', ')}) VALUES (#{values.join(', ')})")
  # result.status
end

def exports.update(table_name, id, data)
  set_data = data.reduce(Array.new) do |buffer, (key, value)|
    buffer << "#{key} = '#{value}'"
  end.join(', ')

  result = DB.exec("UPDATE #{table_name} SET #{set_data} WHERE id=#{id}")
  # result.status
end

def exports.delete(table_name, id)
  result = DB.exec("DELETE from #{table_name} WHERE id=#{id}")
  # result.status
end

#
# data.store_create_table(:posts, title: 'varchar(256)')
def exports.create_table(table_name, attributes)
  definition = attributes.map { |key, value| "#{key} #{value}" }.join(', ')
  result = DB.exec("CREATE table #{table_name} (#{definition})")
  # result.status
end

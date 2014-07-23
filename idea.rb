require 'yaml/store'

class Idea

  attr_reader :title, :description

  def initialize(attributes)
    @title       = attributes["title"]
    @description = attributes["description"]
  end

  # collect ideas as hashes in an array
  def self.raw_ideas
    database.transaction { |db| db['ideas'] || [] }
  end

  # return array with idea instances
  def self.all
    raw_ideas.map { |data| Idea.new(data) }
  end

  def save
    database.transaction do
      database['ideas'] ||= []
      database['ideas'] << {"title" => title, "description" => description}
    end
  end

  def self.delete(position)
    database.transaction do |db|
      database['ideas'].delete_at(position)
    end
  end

  # at method part of Array and Yaml::Store
  # Treat whatever comes out of database['ideas'] as an Array
  # Return an Idea based on its position
  def self.find(id)
    new(find_raw_idea(id))
  end

  def self.find_raw_idea(id)
    database.transaction { database['ideas'].at(id) }
  end

  def self.update(id, data)
    database.transaction { database['ideas'][id] = data }
  end

  def self.database
    @database ||= YAML::Store.new("ideabox")
  end

  def database
    Idea.database
  end

end
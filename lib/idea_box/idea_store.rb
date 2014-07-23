require_relative 'idea'
require 'yaml/store'

class IdeaStore

  def self.database
    @database ||= YAML::Store.new("db/ideabox")
  end

  def self.create(attributes)
    database.transaction do
      database['ideas'] ||= []
      database['ideas'] << attributes
    end
  end

  def self.raw_ideas
    database.transaction { |db| db['ideas'] || [] }
  end

  def self.all
    raw_ideas.map { |data| Idea.new(data) }
  end

  def self.delete(position)
    database.transaction do |db|
      database['ideas'].delete_at(position)
    end
  end

  def self.find(id)
    Idea.new(find_raw_idea(id))
  end

  def self.find_raw_idea(id)
    database.transaction { database['ideas'].at(id) }
  end

  def self.update(id, data)
    database.transaction do
      database['ideas'][id] = data
    end
  end

end
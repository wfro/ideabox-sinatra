require 'yaml/store'

class Idea

  attr_reader :title, :description

  def initialize(title, description)
    @title       = title
    @description = description
  end

  # collect ideas as hashes in an array
  def self.raw_ideas
    database.transaction { |db| db['ideas'] || [] }
  end

  # return array with idea instances
  def self.all
    raw_ideas.map { |data| new(data[:title], data[:description]) }
  end

  def save
    database.transaction do |db|
      db['ideas'] ||= []
      db['ideas'] << {title: title, description: description}
    end
  end

  def self.delete(position)
    database.transaction do |db|
      database['ideas'].delete_at(position)
    end
  end

  def self.database
    @database ||= YAML::Store.new("ideabox")
  end

  def database
    Idea.database
  end

end
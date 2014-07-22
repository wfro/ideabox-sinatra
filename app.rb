require './idea'

class IdeaBoxApp < Sinatra::Base

  set(:method_override, true)

  configure :development do
    register Sinatra::Reloader
  end

  not_found do
    erb(:error)
  end

  get '/' do
    erb(:index, locals: {ideas: Idea.all})
  end

  post '/' do
    # 1. Create an idea based on the form parameters
    idea = Idea.new(params['idea_title'], params['idea_description'])
    # 2. Store it
    idea.save
    # 3. Send us back to the index page to see all ideas
    redirect('/')
  end

  delete '/:id' do |id|
    Idea.delete(id.to_i)
    redirect('/')
  end

end
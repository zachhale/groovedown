require 'libraries'

module Groovedown
  class App < Sinatra::Base
    helpers Groovedown::Helpers

    set :static, true
    set :public, File.dirname(__FILE__) + "/public"
                       
    get '/' do
      erb :index
    end
    
    get '/search' do
      redirect '/'
    end
    
    post '/search' do
	    p params
      @results = Result.find(params)
      erb :search, :layout => false
    end
    
    get "/songs/:id" do 
      @stream = Stream.new(params[:id])
      if data = @stream.get
        content_type "mp3"
        attachment "#{params[:name]||params[:id]}.mp3"
        halt data.to_s
      else
        "They don't like us. :("
      end
    end

  end
end
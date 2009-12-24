require 'libraries'

module Groovedown
  class App < Sinatra::Base
    helpers Groovedown::Helpers
    
    if ENV['RACK_ENV'] == 'development'
      use Rack::LessCss, :less_path => File.join(File.dirname(__FILE__), "views", "css", "less"),
                         :css_route => "/css"
      use Rack::Evil
    end
                       
    get '/' do
      haml :index
    end
    
    get '/search' do
      redirect '/'
    end
    
    post '/search' do      
      @results = Result.find(params)
      haml :search
    end
    
    get "/songs/:id" do  
	    content_type "mp3"
  
      @stream = Stream.new(params[:id])
      if data = @stream.get
        data 
      else
        "They don't like us. :("
      end
    end
  end
end
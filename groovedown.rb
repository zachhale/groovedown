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
      haml :search
    end
    
    get "/songs/:id" do 
      @stream = Stream.new(params[:id])
      throw :response, [200, {"Content-Type" => "audio/mpeg", "Content-Length" => @stream.length }, @stream]
    end

  end
end
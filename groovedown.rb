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
      @results = Result.find(params)
      erb :search, :layout => false
    end
    
    get "/songs/:id" do 
      @stream = Stream.new(params[:id])
      redirect "/songs/#{@stream.key}/#{@stream.server}"
    end

  end
end
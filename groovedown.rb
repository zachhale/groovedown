require 'libraries'

module Groovedown
  class App < Sinatra::Base
    use Rack::LessCss, :less_path => File.join(File.dirname(__FILE__), "views", "css", "less"),
                       :css_route => "/css"
                       
    get '/' do
      haml :index
    end
  end
end
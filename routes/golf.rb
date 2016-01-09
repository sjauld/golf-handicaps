class App < Sinatra::Base

  include Rack::Utils

  get '/' do
    haml :index
  end

end

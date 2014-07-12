class DreamOn::Controllers::Api < Sinatra::Base
  require 'json'
  #set view directory as /views/apis for this controller views
  set :views,  File.join(root, '../views/apis' )

  #  add your own routes TODO
    get '/' do
      erb :index
    end
    
    get '/after_login' do
      erb :after_login
    end

    get '/after_search' do
      erb :after_search
    end
    get '/second' do
      erb :second
    end
    get '/search' do
      erb :search
    end
end


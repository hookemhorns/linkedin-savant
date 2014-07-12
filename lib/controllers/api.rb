class DreamOn::Controllers::Api < Sinatra::Base

  #set view directory as /views/apis for this controller views
  set :views,  File.join(root, '../views/apis' )

  #  add your own routes TODO
    get '/' do
      erb :index
    end

    get '/second' do
      erb :second
    end
end


class DreamOn::Controllers::Ping < Sinatra::Base
  get '/ping' do
    body "Ahoy! from DreamOn #{Time.now}"
  end
end

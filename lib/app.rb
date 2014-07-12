module DreamOn
  class App < Sinatra::Base
    set :root, File.join(File.dirname(__FILE__), '..')
    set :vendor, 'FIX add your vendor name'

    use DreamOn::Controllers::Ping
    use DreamOn::Controllers::Profile
  end
end


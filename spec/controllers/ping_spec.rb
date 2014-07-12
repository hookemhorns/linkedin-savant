require 'spec_helper'

describe  DreamOn::Controllers::Ping do	
  def app
    DreamOn::Controllers::Ping
  end

    describe "get /ping" do
      it "should return 200" do
        get :ping
        last_response.body.should == "Ahoy! from DreamOn #{Time.now}"
        last_response.status.should == 200
      end
    end
end


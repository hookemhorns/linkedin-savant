require 'spec_helper'

describe  DreamOn::Controllers::Api do	
  def app
    DreamOn::Controllers::Api
  end

  it "should do nothing" do
    get '/'
    last_response.status.should == 200
  end
end



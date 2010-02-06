require 'test_helper'

class BundlesControllerTest < ActionController::TestCase
  test "POST /bundles should succeed" do
    post :create, :bundle => { :url => "http://localhost" }
    assert_response :success
  end
end

require 'test_helper'

class LandingControllerTest < ActionController::TestCase
  test "GET / should be a success" do
    get :root
    assert_response :success
  end

  test "GET / should assign @bundle" do
    get :root
    assert assigns(:bundle)
  end
end

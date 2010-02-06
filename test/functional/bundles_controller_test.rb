require 'test_helper'

class BundlesControllerTest < ActionController::TestCase
  def setup
    @bundle = bundles(:localhost)
  end

  test "POST /bundles should redirect to the created bundle" do
    post :create, create_params
    assert_redirected_to bundle_url(assigns(:bundle))
  end

  test "POST /bundles should create a bundle" do
    count = Bundle.count
    post :create, create_params
    assert_equal count + 1, Bundle.count
  end

  def create_params
    { :bundle => { :url => "http://localhost" }}
  end

  test "GET /bundles/1 should show the bundle" do
    get :show, :id => @bundle
  end
end

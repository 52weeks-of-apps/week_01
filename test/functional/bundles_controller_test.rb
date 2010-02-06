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

  test "POST /bundles should not create a bundle for existing url" do
    existing = @bundle
    count = Bundle.count
    post :create, { :bundle => { :url => existing.url } }
    assert_equal count, Bundle.count
    assert_redirected_to bundle_url(existing)
  end

  def create_params
    { :bundle => { :url => "http://localhost" }}
  end

  test "GET /bundles/1 should show the bundle" do
    get :show, :id => @bundle
  end
end

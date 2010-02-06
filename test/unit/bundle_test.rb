require 'test_helper'

class BundleTest < ActiveSupport::TestCase
  def setup
    @bundle = Bundle.new(valid_bundle_attributes)
  end

  test "is valid" do
    assert @bundle.valid?
  end

  test "requires url" do
    @bundle.url = nil
    assert !@bundle.valid?
  end

  test "fetching url" do
    assert_nil @bundle.body
    @bundle.update_body!
    assert_not_nil @bundle.body
  end
end

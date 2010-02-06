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

  test "fetching a url should populate script tags" do
    js_response = "document.body.write('hi')"
    js_url      = 'http://localhost/blah.js'
    Typhoeus::Response.response_bodies[@bundle.url] = "<p>hi</p><script src='#{js_url}' type='text/javascript'></script>"
    Typhoeus::Response.response_bodies[js_url] = js_response

    @bundle.update_body!
    assert_equal Nokogiri::HTML("<p>hi</p><script type='text/javascript'>#{js_response}</script>").to_s, @bundle.body
  end

  test "fetching a url should populate stylesheet tags" do
    css_response = 'p { color: black }'
    css_url = '<link href="/stylesheets/blueprint/screen.css?1259020613" media="screen, projector" rel="stylesheet" type="text/css" />
    '
    Typhoeus::Response.response_bodies[@bundle.url] = "<p>hi</p><link href='#{css_url}' media='screen' rel='stylesheet' type='text/css' />"
    Typhoeus::Response.response_bodies[css_url] = css_response

    @bundle.update_body!
    assert_equal Nokogiri::HTML("<p>hi</p><style media='screen' type='text/css'>#{css_response}</style>").to_s, @bundle.body
  end
end

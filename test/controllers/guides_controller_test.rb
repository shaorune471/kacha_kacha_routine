require "test_helper"

class GuidesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should get index" do
    sign_in users(:one)
    get guide_url
    assert_response :success
  end
end

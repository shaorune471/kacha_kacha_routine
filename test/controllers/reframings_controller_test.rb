require "test_helper"

class ReframingsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get reframing_url
    assert_response :success
  end
end

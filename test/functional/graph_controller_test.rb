require 'test_helper'

class GraphControllerTest < ActionController::TestCase
  test "should get draw" do
    get :draw
    assert_response :success
  end

end

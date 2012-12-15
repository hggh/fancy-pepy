require 'test_helper'

class GraphitesControllerTest < ActionController::TestCase
  test "should get draw" do
    get :draw
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get tag" do
    get :tag
    assert_response :success
  end

end

require 'test_helper'

class DirectMessagesControllerTest < ActionController::TestCase
  def setup
    @user  = users(:michael)
    @other = users(:lana)
  end

  test "need to log in" do
    get :index
    assert_redirected_to login_url

    get :talk, to_user_id: @other
    assert_redirected_to login_url

    post :talk, to_user_id: @other
    assert_redirected_to login_url

    log_in_as @user

    get :index
    assert_response :success

    get :talk, to_user_id: @other
    assert_response :success

    post :talk, to_user_id: @other
    assert_response :success
  end
end

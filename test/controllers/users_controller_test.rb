require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @user  = users(:michael)
    @other = users(:archer)
  end

  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to login_url
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get :edit, id: @user
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch :update, id: @user, user: {name: @user.name, email: @user.email}
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as @other
    get :edit, id: @user
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong uesr" do
    log_in_as @other
    patch :update, id: @user, user: {name: @user.name, email: @user.email}
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other)
    assert_not @other.admin?

    pass = "password"
    user_params = {
      password:              pass,
      password_confirmation: pass,
      admin: "1"
    }
    patch :update, id: @other, user: user_params
    assert_not @other.reload.admin?
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference "User.count" do
      delete :destroy, id: @user
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as @other
    assert_no_difference "User.count" do
      delete :destroy, id: @user
    end
    assert_redirected_to root_url
  end

  test "should redirect following when not logged in" do
    get :following, id: @user.id
    assert_redirected_to login_url
  end

  test  "should redirect followers when not logged in" do
    get :following, id: @user.id
    assert_redirected_to login_url
  end
end

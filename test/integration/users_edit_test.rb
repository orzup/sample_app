require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "unsuccessfull edit" do
    log_in_as @user
    get edit_user_path(@user)
    assert_template "users/edit"

    user_params = {
      name:                  "",
      email:                 "foo@invalid",
      password:              "foo",
      password_confirmation: "bar"
    }
    patch user_path(@user), user: user_params
    assert_template "users/edit"
  end

  test "successfull edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as @user
    assert_redirected_to edit_user_path(@user)

    name  = "Foo Bar"
    email = "foo@bar.com"
    user_params = {
      name:                  name,
      email:                 email,
      password:              "",
      password_confirmation: ""
    }
    patch user_path(@user), user: user_params
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
end

require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end

  test "password resets" do
    get new_password_reset_path
    assert_template "password_resets/new"

    # invalid email
    post password_resets_path password_reset: {email: ""}
    assert_not flash.empty?
    assert_template "password_resets/new"

    # valid mail
    post password_resets_path, password_reset: {email: @user.email}
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url

    user = assigns(:user)

    # wrong email
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url

    # inactive user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)

    # wrong token, right email
    get edit_password_reset_path("wrong token", email: user.email)
    assert_redirected_to root_url

    # right token, right email
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template "password_resets/edit"
    assert_select "input[name=email][type=hidden][value=?]", user.email

    # invalid pass & confirmation
    patch(
      password_reset_path(user.reset_token),
      email: user.email,
      user: {password: "hogehoge", password_confirmation: "fugafuga"}
    )
    assert_select "div#error_explanation"

    # empty pass
    patch(
      password_reset_path(user.reset_token),
      email: user.email,
      user: {password: "", password_confirmation: ""}
    )
    assert_not flash.empty?
    assert_template "password_resets/edit"

    # valid pass & confirmation
    patch(
      password_reset_path(user.reset_token),
      email: user.email,
      user: {password: "hogehoge", password_confirmation: "hogehoge"}
    )
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end

  test "expired token" do
    get new_password_reset_path
    post password_resets_path, password_reset: {email: @user.email}

    @user = assigns(:user)
    @user.update_attribute(:reset_sent_at, 3.hours.ago)

    user_params = {password: "foobar", pasword_confirmation: "foobar"}
    patch password_reset_path(@user.reset_token),
          email: @user.email, user:  user_params

    assert_response :redirect
    follow_redirect!

    assert_match /expired/i, response.body
  end
end

require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "layout links" do
    get root_path

    assert_template "static_pages/home"
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
  end

  test "layout links (logged-in)" do
    @user = users(:michael)
    log_in_as @user
    get root_path

    assert_template "static_pages/home"
    assert_select "div.stats"
    assert_select "a[href=?]", following_user_path(@user)
    assert_select "a[href=?]", followers_user_path(@user)
    assert_match @user.following.count.to_s, response.body
    assert_match @user.followers.count.to_s, response.body
  end

  test "signup page's title" do
    get signup_path
    assert_select "title", full_title("Sign up")
  end
end

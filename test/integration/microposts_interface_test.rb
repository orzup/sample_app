require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "micropost interface" do
    log_in_as @user
    get root_path

    assert_select "div.pagination"
    assert_select "input[type=file]"

    # invalid submission
    assert_no_difference "Micropost.count" do
      post microposts_path, micropost: {content: ""}
    end
    assert_select "div#error_explanation"

    # valid submission
    content = "This micropost really ties the room together"
    picture = fixture_file_upload("test/fixtures/rails.png", "image/png")
    assert_difference "Micropost.count", 1 do
      post microposts_path, micropost: {content: content, picture: picture}
    end
    assert assigns(:micropost).picture?
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body

    # delete a post
    assert_select "a", text: "delete"
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference "Micropost.count", -1 do
      delete micropost_path(first_micropost)
    end

    # visit a different user
    get user_path(users :archer)
    assert_select "a", text: "delete", count: 0
  end

  test "micropost sidebar count" do
    log_in_as @user
    get root_path

    assert_match "#{@user.microposts.count} microposts", response.body

    # user with zero microposts
    other = users(:mallory)
    log_in_as other
    get root_path
    assert_match "0 microposts", response.body

    other.microposts.create!(content: "A micropost")
    get root_path
    assert_match "1 micropost", response.body
  end
end

require 'test_helper'

class DirectMessagesIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    log_in_as @user
  end

  test "listed users should follow michael and michael follows him/her" do
    get direct_messages_path

    assert assigns(:target_users).all? {|user| user.following? @user }
    assert assigns(:target_users).all? {|user| @user.following? user }
  end

  test "links to talk page should be there" do
    get direct_messages_path

    assigns(:target_users).each do |user|
      assert_select "a[href=?]", direct_messages_talk_path(user)
    end
  end
end

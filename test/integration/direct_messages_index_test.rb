require 'test_helper'

class DirectMessagesIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @friend = users(:lana)
    @other = users(:archer)
    log_in_as @user
  end

  test "listed user and michael follow each other or talked before" do
    get direct_messages_path

    assert assigns(:target_users).all? do |user|
      (user.following?(@user) && @user.following?(user))||
      DirectMessage.where(from_user:  user, to_user: @user).count > 0 ||
      DirectMessage.where(from_user: @user, to_user:  user).count > 0
    end
  end

  test "links to talk page should be there" do
    get direct_messages_path

    assigns(:target_users).each do |user|
      assert_select "a[href=?]", direct_messages_talk_path(user)
    end
  end

  test "mutual friend DM page should have message form" do
    get direct_messages_talk_path(@friend)
    assert_select "form[id=?]", "new_direct_message"
  end

  test "non-mutual friend DM page should not have message form" do
    get direct_messages_talk_path(@other)
    assert_select "form[id=?]", "new_direct_message", count: 0
  end
end

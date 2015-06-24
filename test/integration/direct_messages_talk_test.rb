require 'test_helper'

class DirectMessagesTalkTest < ActionDispatch::IntegrationTest
  def setup
    @user  = users(:michael)
    @other = users(:lana)

    log_in_as @user
  end

  test "our direct messages are rendered" do
    get direct_messages_talk_path(@other)

    count  =  @user.direct_messages.select {|msg| msg.to_user_id == @other.id }.count
    count += @other.direct_messages.select {|msg| msg.to_user_id == @user.id  }.count

    assert_select "div.talk", count: count
  end

  test "should send a DM successfully" do
    get direct_messages_talk_path(@other)

    params = {content: "This is a DM for test"}
    assert_difference "DirectMessage.count", 1 do
      post direct_messages_talk_path(@other), direct_message: params
    end

    assert_redirected_to direct_messages_talk_path(@other)
    follow_redirect!

    assert_match "This is a DM for test", response.body
  end

  test "fail to send a DM" do
    get direct_messages_talk_path(@other)

    params = {content: ""}
    assert_no_difference "DirectMessage.count" do
      post direct_messages_talk_path(@other), direct_message: params
    end

    assert_redirected_to direct_messages_talk_path(@other)
    follow_redirect!

    assert_no_match "This is a DM for test", response.body
  end
end

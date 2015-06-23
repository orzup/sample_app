require 'test_helper'

class DirectMessageTest < ActiveSupport::TestCase
  def setup
    @one = direct_messages(:one)
    @two = direct_messages(:two)
  end

  test "should be valid" do
    assert @one.valid?
    assert @two.valid?
  end

  test "should have content" do
    @one.content = "   "
    assert_not @one.valid?
  end

  test "content should be at most 10000 characters" do
    @one.content = "a"*10000
    assert @one.valid?

    @one.content = "a"*10001
    assert_not @one.valid?
  end

  test "should have from_user_id" do
    @one.from_user_id = nil
    assert_not @one.valid?
  end

  test "should have to_user_id" do
    @one.to_user_id = nil
    assert_not @one.valid?
  end

  test "users relation" do
    assert @one.from_user == users(:michael)
    assert @one.to_user   == users(:lana)
  end
end

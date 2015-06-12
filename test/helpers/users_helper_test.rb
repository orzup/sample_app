require 'test_helper'

class UsersHelperTest < ActionView::TestCase
  test "gravatar_for" do
    mock_user = Struct.new(:name, :email).new
    mock_user.name  = "John Doe"
    mock_user.email = "user@example.com"

    assert_match    "?s=80", gravatar_for(mock_user)
    assert_match    "?s=50", gravatar_for(mock_user, {size: 50})
    assert_no_match "?s=80", gravatar_for(mock_user, {size: 50})
  end
end

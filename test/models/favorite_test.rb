require 'test_helper'

class FavoriteTest < ActiveSupport::TestCase
  def setup
    @user      = users(:michael)
    @micropost = users(:archer).microposts.first
    @favorite  = Favorite.new(user_id: @user.id, micropost_id: @micropost.id)
  end

  test "should be valid" do
    assert @favorite.valid?
  end

  test "should require a user_id" do
    @favorite.user_id = nil
    assert_not @favorite.valid?
  end

  test "should require a micropost_id" do
    @favorite.micropost_id = nil
    assert_not @favorite.valid?
  end
end

require 'test_helper'

class FavoriteIntegrationTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @micropost = microposts(:orange)
    log_in_as @user
  end

  test "should favor a post the standard way" do
    assert_difference "@user.favorite_posts.count", 1 do
      post favorites_path, micropost_id: @micropost.id
    end
  end

  test "should favor a post with Ajax" do
    assert_difference "@user.favorite_posts.count", 1 do
      xhr :post, favorites_path, micropost_id: @micropost.id
    end
  end

  test "should unfavor a post the standard way" do
    @user.favor(@micropost)
    favorite = @user.favorites.find_by(micropost_id: @micropost.id)
    assert_difference "@user.favorite_posts.count", -1 do
      delete favorite_path(favorite), micropost_id: @micropost.id
    end
  end

  test "should unfavor a post with Ajax" do
    @user.favor(@micropost)
    favorite = @user.favorites.find_by(micropost_id: @micropost.id)
    assert_difference "@user.favorite_posts.count", -1 do
      xhr :delete, favorite_path(favorite), micropost_id: @micropost.id
    end
  end
end

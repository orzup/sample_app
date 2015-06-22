class FavoritesController < ApplicationController
  before_action :logged_in_user

  def create
    @user      = current_user
    @micropost = Micropost.find(params[:micropost_id])

    @user.favor(@micropost)
    respond_to do |format|
      format.html { redirect_back_or @user }
      format.js
    end
  end

  def destroy
    @user      = current_user
    @micropost = Favorite.find(params[:id]).micropost

    @user.unfavor(@micropost)
    respond_to do |format|
      format.html { redirect_back_or @user }
      format.js
    end
  end
end

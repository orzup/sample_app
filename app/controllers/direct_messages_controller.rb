class DirectMessagesController < ApplicationController
  before_action :logged_in_user
  before_action :following_each_other, only: [:talk, :create]

  def index
    @target_users = (current_user.following & current_user.followers).paginate(page: params[:page])
  end

  def talk
    @new_message = current_user.direct_messages.build

    cond_sql = "(from_user_id = ? AND to_user_id = ?) OR (to_user_id = ? AND from_user_id = ?)"
    @messages = DirectMessage.where(
      cond_sql, current_user.id, @user.id, current_user.id, @user.id
    ).paginate(page: params[:page])
  end

  def create
    if current_user.following_each_other?(@user)
      params = {to_user_id: @user.id, content: dm_params[:content]}
      current_user.direct_messages.build(params).save
    end

    redirect_to direct_messages_talk_path(@user)
  end

  private

  def following_each_other
    @user = User.find(params[:to_user_id])

    redirect_to direct_messages_path unless current_user.following_each_other?(@user)
  end

  def dm_params
    params.require(:direct_message).permit(:content)
  end
end

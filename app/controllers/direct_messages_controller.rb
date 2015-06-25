class DirectMessagesController < ApplicationController
  before_action :logged_in_user
  before_action :talked_once_or_mutual_friend, only: [:talk]
  before_action :mutual_friends, only: [:create]

  def index
    mutual_friends = (current_user.following & current_user.followers)
    @target_users = (mutual_friends | users_talked_once)
    @target_users = @target_users.sort_by(&:id).paginate(page: params[:page])
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

  def talked_once_or_mutual_friend
    @user = User.find(params[:to_user_id])

    mutual_friends = (current_user.following & current_user.followers)
    talked_users   = users_talked_once

    redirect_to direct_massage_path unless (mutual_friends | talked_users).include? @user
  end

  def mutual_friends
    @user = User.find(params[:to_user_id])

    redirect_to direct_messages_path unless current_user.following_each_other?(@user)
  end

  def users_talked_once
    talked_user_ids = DirectMessage.where(from_user_id: current_user.id)
                                   .select(:to_user_id)
                                   .uniq.map(&:to_user_id) |
                      DirectMessage.where(to_user_id: current_user.id)
                                   .select(:from_user_id)
                                   .uniq.map(&:from_user_id)
    talked_users = User.where(id: talked_user_ids)
  end

  def dm_params
    params.require(:direct_message).permit(:content)
  end
end

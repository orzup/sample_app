class DirectMessage < ActiveRecord::Base
  belongs_to :from_user, class_name: "User"
  belongs_to :to_user,   class_name: "User"

  default_scope -> {order created_at: :desc}

  validates :content, presence: true, length: {maximum: 10000}
  validates :from_user_id, presence: true
  validates :to_user_id,   presence: true
end

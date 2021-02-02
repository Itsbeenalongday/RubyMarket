class Comment < ApplicationRecord

  paginates_per 5
  
  belongs_to :user, optional: true # 탈퇴회원의 댓글
  belongs_to :item, optional: true
  has_many :likes, as: :likable, dependent: :destroy

end

class Comment < ApplicationRecord
  belongs_to :user, optional: true # 탈퇴회원의 댓글
  belongs_to :item
end

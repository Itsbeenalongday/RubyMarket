class Order < ApplicationRecord
  belongs_to :user, optional: true # 회원 탈퇴해도 주문은 남아있도록 
  
  has_many :line_items, dependent: :destroy # 주문 삭제되면 주문항목도 남아있을 필요 없음

  enum status: [:paid, :canceled, :cart]
  # 완료, 취소, 장바구니

  scope :paid, -> {where.not(paid_at: nil)}
  scope :canceled, -> {where.not(cancled_at: nil)}
  
end

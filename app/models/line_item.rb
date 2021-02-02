class LineItem < ApplicationRecord
  belongs_to :item, optional: true # 상품 삭제되도 주문목록에는 남아있어야
  belongs_to :order, optional: true # 주문이 삭제되면 주문목록도 같이 삭제

  after_destroy :set_order_total

  def set_order_total
    self.order.update(total: self.order.line_items.sum("price"))
  end
end
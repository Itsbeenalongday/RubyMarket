class LineItem < ApplicationRecord
  belongs_to :item, optional: true # 상품 삭제되도 주문목록에는 남아있어야
  belongs_to :order, optional: true # 주문이 삭제되면 주문목록도 같이 삭제

  after_save :set_order_total
  
  def set_order_total
    # 미처 몰랐는데, 여기는 line_item인데 아래처럼 order로 써도 알아서 찾아간다.
    order.update(total: order.line_items.sum("quantity * price"))
  end
end
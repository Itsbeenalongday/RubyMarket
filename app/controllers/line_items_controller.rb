class LineItemsController < ApplicationController
  before_action :load_line_item, only: [:destroy, :update, :edit]
  
  def destroy
    order = @line_item.order
    @line_item.destroy
  end

  def update
    @index = params[:line_item][:index].to_i
    @price = @line_item.price # 기존 가
    @total = @line_item.order.total # 기존 총계
    @total = @total - @price + Item.find_by(id: @line_item.item_id).price * params[:line_item][:quantity].to_i # 기존 총계 - 기존 가격 + 새로운 가격
    @line_item.order.update(total: @total)
    @line_item.update(quantity: params[:line_item][:quantity].to_i, price: Item.find_by(id: @line_item.item_id).price * params[:line_item][:quantity].to_i)
  end

  def edit
   @index = params[:index]
  end

  private

  def load_line_item
    @line_item = current_user.orders.find_by(id: params[:order_id]).line_items.find_by(id: params[:id])
  end

end

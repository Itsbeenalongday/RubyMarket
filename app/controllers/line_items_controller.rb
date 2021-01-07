class LineItemsController < ApplicationController
  before_action :load_line_item, only: [:destroy, :update, :edit]
  
  def destroy
    @line_item.destroy
  end

  def update
    @line_item.update(quantity: params[:line_item][:quantity], price: Item.find_by(id: @line_item.item_id).price * params[:line_item][:quantity].to_i)
  end

  def edit;end

  private

  def load_line_item
    @line_item = current_user.orders.find_by(id: params[:order_id]).line_items.find_by(id: params[:id])
  end

end

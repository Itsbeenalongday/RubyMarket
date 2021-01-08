class OrdersController < ApplicationController
  before_action :get_cart ,only: [:new, :edit]
  before_action :load_order, except: [:index, :new]

  def new;end
  
  def edit;end

  def update
    @order.paid!
    @order.update(paid_at: Time.now, number: rand(1_000_000_000..9_999_999_999))
    redirect_to root_path, notice: "주문이 완료되었습니다."
  end

  def index
    @orders = current_user.orders.paid # scope로 미리 지정해놧음
  end

  def show;end

  def destroy
    @order.canceled!
    redirect_to root_path, notice: "주문이 취소되었습니다."
  end

  private
  
  def load_order
    @order = Order.find_by(id: params[:id])
  end

  def check_owner
    redirect_to root_path, notice: "권한이 없습니다." unless @order.user == current_uesr
  end
end

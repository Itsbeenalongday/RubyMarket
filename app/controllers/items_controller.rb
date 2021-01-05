class ItemsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_item, only: [:show, :add]
  before_action :safe_load_item, only: [:edit, :update, :destroy]
  
  def index
    # hash형태로 params에서 넘겨주면 바로 받아오면 된다.
    # 예시
    
    # 카테고리 별
    # params[:q] == {"category_id_eq":"#{category.id}"}

    # 내가 판매 중인 상품
    # params[:q] == {"user_id_eq":"#{current_user.id}"}
    @items = Item.ransack(params[:q]).result
  end
  
  def new
    @item = Item.new
  end
  
  def create
    @item = Item.create item_params
    redirect_to root_path, notice: "상품을 성공적으로 등록하였습니다."
  end
  
  def edit;end
  
  def update
    @item = Item.update item_params
    redirect_to root_path, notice: "상품을 성공적으로 수정하였습니다."
  end
  
  def show;end

  def add 
    @order = get_cart
    # 현재 아이템을 담고있는 주문목록이 있는지 확인 없으면 만든다.
    @line_item = @order.line_items.find_or_initialize_by(item: @item)
    @line_item.quantity.nil? ? @line_item.update(quantity: params[:quantity], price: @item.price) : @line_item.update(quantity: @line_item.quantity + params[:quantity].to_i)
    @line_item.set_order_total
  end
  
  # routing에 추가 member 액션임
  def toggle_like
  
  end

  private  
  
  def load_item
    @item = Item.find_by(id: params[:id])
  end

  def safe_load_item
    @item = Item.ransack(user_id_eq: current_user.id).result.ransack(id_eq: params[:id]).result(distinct: true).uniq
  end
  
  def item_params
    params.require(:item).permit(:title, :description, :price, :image, :category_id, :user_id)
  end
end

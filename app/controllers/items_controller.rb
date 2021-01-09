class ItemsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :load_item, only: [:show, :add, :toggle_like]
  before_action :safe_load_item, only: [:edit, :update, :destroy]
  protect_from_forgery except: :show
  
  def index
    #byebug
    order = { "최신순" => "created_at DESC", "높은가격순" => "price DESC", "이름순" => "title", "낮은가격순" => "price" }
    query = params[:query] if params[:query]
    query = { "title_or_description" => params[:s], "category_id" => nil, "user_id" => nil } if query=="query"
    query ? @items = Item.ransack(title_or_description_i_cont: query["title_or_description"], category_id_eq: query["category_id"], user_id_eq: query["user_id"]).result : @items = Item.all
    @items = @items.where(id: current_user.likes.where(likable_id: @items, likable_type: "Item").map(&:likable_id)) if params[:type] == "my" && current_user
    params[:order] ? @items = @items.order(order[params[:order]]).page(params[:page]) : @items = @items.page(params[:page])
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
    @item = @item.update item_params
    redirect_to root_path, notice: "상품을 성공적으로 수정하였습니다."
  end

  def toggle_like
    @like = current_user.likes.find_or_initialize_by(likable_id: @item.id, likable_type: "Item")
    @like.new_record? ? @like.save : @like.destroy
    @likes = @item.likes.count
    render 'items/likable.js', locals: { like: @like.destroyed? ? true : false, likes: @likes }
  end
  
  def show
    @comments = @item.comments.page(params[:page])
    @like = current_user.likes.find_by(likable_id: @item.id, likable_type: "Item")
    @likes = @item.likes.count
  end

  def destroy
    if @item.line_items.present?
      @item.line_items.each do |line_item|
        line_item.order.update(total: line_item.order.total - (line_item.quantity * @item.price)) if line_item.order.cart?
      end
    end
    @item.destroy
    redirect_to root_path, notice: "상품을 성공적으로 삭제하였습니다."
  end


  def add
    @cart = get_cart
    # 현재 아이템을 담고있는 주문목록이 있는지 확인 없으면 만든다.
    @line_item = @cart.line_items.find_or_initialize_by(item: @item)
    if @line_item.new_record? # 새로운 주문항목
      @line_item.update(quantity: params[:quantity], price: @item.price*params[:quantity].to_i)
      @line_item.order.total = 0 if @line_item.order.total.nil? # 첫 주문 상품
      @line_item.order.update(total: @line_item.order.total + @item.price*params[:quantity].to_i)
    else # 기존 항목 추가됨
      previous_quantity = @line_item.quantity
      @line_item.update(quantity: @line_item.quantity + params[:quantity].to_i, price: @item.price * (@line_item.quantity + params[:quantity].to_i))
      @line_item.order.update(total: @line_item.order.total - (previous_quantity * @item.price) + @item.price * (previous_quantity + params[:quantity].to_i))
    end
  end

  private  
  
  def load_item
    @item = Item.find_by(id: params[:id])
  end

  def safe_load_item
    @item = current_user.items.find_by(id:params[:id])
  end
  
  def item_params
    params.require(:item).permit(:title, :description, :price, :image, :category_id, :user_id)
  end
end

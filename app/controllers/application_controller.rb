class ApplicationController < ActionController::Base
  before_action :authenticate_user!, only: [:get_cart]
  helper_method :pretty_time, :query_string
  
  def get_cart
    @order = current_user.orders.cart.first_or_create
  end

  def pretty_time(time = nil)
    time.methods.include?(:strftime) ? time.strftime("%Y-%m-%d %H:%M") : ""
  end

  def query_string(search: nil, category: nil, user: nil)
    {:title_or_description => search, :category_id => category, :user_id  => user}
  end

end

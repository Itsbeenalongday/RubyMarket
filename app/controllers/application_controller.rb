class ApplicationController < ActionController::Base
  before_action :authenticate_user!, only: [:get_cart]
  
  def get_cart
    @order = current_user.orders.cart.first_or_create
  end
end

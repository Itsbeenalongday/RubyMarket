class ApplicationController < ActionController::Base
  before_action :authenticate_user!, only: [:get_cart]
  helper_method :pretty_time, :query_string, :pretty_date
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  def get_cart
    @cart = current_user.orders.cart.first_or_create
  end

  def pretty_date(time = nil)
    time.methods.include?(:strftime) ? time.strftime('%Y-%m-%d') : ''
  end

  def pretty_time(time = nil)
    time.methods.include?(:strftime) ? time.strftime("%Y-%m-%d %H:%M") : ""
  end

  def query_string(search: nil, category: nil, user: nil)
    {:title_or_description => search, :category_id => category, :user_id  => user}
  end

  def pretty_date(time = nil)
    time.methods.include?(:strftime) ? time.strftime('%Y-%m-%d') : ''
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: [:name]
    devise_parameter_sanitizer.permit :account_update, keys: [:name]
    devise_parameter_sanitizer.permit :sign_up, keys: [:phone]
    devise_parameter_sanitizer.permit :account_update, keys: [:phone]
  end

end

# -*- encoding : utf-8 -*-
module CustomerSessionsHelper
	def store_location
    session[:return_to] = request.fullpath
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  def clear_return_to
    session[:return_to] = nil
  end

  def current_customer_session
	  return @current_customer_session if defined?(@current_customer_session)
	  @current_customer_session = CustomerSession.find
	end

	def current_customer
	  @current_customer = current_customer_session && current_customer_session.record
	end

	def current_customer?(customer)
	  current_customer == customer
	end

	def signed_in_customer?
    !current_customer.nil?
  end

  def require_customer
    if request.mobile?
      unless current_customer
        store_location
        flash[:notice] = "このページにアクセスするにはログインが必要です。"
        redirect_to customer_signin_path
        return false
      end
    else
      flash[:notice] = "携帯端末以外からのアクセスができません。"
      redirect_to root_path
      return false
    end
  end

  def require_correct_customer
    coupon = Coupon.find(params[:id])
    if request.mobile?
      if current_customer.nil?
        store_location
        flash[:notice] = "このページにアクセスするにはログインが必要です。"
        redirect_to customer_signin_path
        return false
      elsif !current_customer.has_coupon?(coupon)
        redirect_to coupons_path
      end
    else
      flash[:notice] = "携帯端末以外からのアクセスができません。"
      redirect_to root_path
      return false
    end
  end

  def require_no_customer
    if current_customer
      flash[:notice] = "このページにアクセスするにログアウトが必要です。"
      redirect_to root_path
      return false
    end
  end

  def require_correct_customer_or_admin
    @customer = Customer.find(params[:id])
    unless current_customer?(@customer) || admin_master?
      flash[:notice] = "このページにアクセスする必要な権限がありません。"
      redirect_to(root_path)
      return false
    end
  end
end


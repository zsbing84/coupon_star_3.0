# -*- encoding : utf-8 -*-
module MasterSessionsHelper

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

  def current_master_session
	  return @current_master_session if defined?(@current_master_session)
	  @current_master_session = MasterSession.find
	end

	def current_master
	  return @current_master if defined?(@current_master)
	  @current_master = current_master_session && current_master_session.master
	end

	def current_master?(master)
	  current_master == master
	end

	def admin_master?
	  if current_master
	   current_master.admin
    end
	end

	def signed_in_master?
    !current_master.nil?
  end

  def require_master
    unless current_master
      store_location
      flash[:notice] = "このページにアクセスするにはログインが必要です。"
      redirect_to master_signin_path
      return false
    end
  end

  def require_no_master
    if current_master
      flash[:notice] = "このページにアクセスするにはログアウトが必要です。"
      redirect_to root_path
      return false
    end
  end

  def require_master_or_customer
		if request.mobile?
			unless current_customer
				store_location
    		flash[:notice] = "このページにアクセスするにはログインが必要です。"
				redirect_to customer_signin_path
				return false
			end
		else
			unless current_master
				store_location
    		flash[:notice] = "このページにアクセスするにはログインが必要です。"
				redirect_to master_signin_path
				return false
			end
		end
  end

  def require_correct_master
    master = Master.find(params[:id])
    unless current_master?(master) || admin_master?
			flash[:notice] = "このページにアクセスする必要な権限がありません。"
			redirect_to(root_path)
			return false
		end
  end

  def require_correct_coupon_master
  	coupon = Coupon.find(params[:id])
  	master = coupon.shop.master
    unless current_master?(master) || admin_master?
			flash[:notice] = "このページにアクセスする必要な権限がありません。"
			redirect_to(root_path)
			return false
		end
  end

  def require_correct_shop_master
  	shop = Shop.find(params[:id])
  	master = shop.master
    unless current_master?(master) || admin_master?
			flash[:notice] = "このページにアクセスする必要な権限がありません。"
			redirect_to(root_path)
			return false
		end
  end

	def require_admin
		unless admin_master?
			flash[:notice] ="このページにアクセスする必要な権限がありません。"
			redirect_to(root_path)
			return false
		end
	end

	def require_mobile_request
		unless request.mobile?
			flash[:notice] = "携帯端末以外からのアクセスができません。"
			redirect_to(root_path)
			return false
		end
	end

	def require_no_mobile_request
		if request.mobile?
			flash[:notice] = "携帯端末からのアクセスができません。"
			redirect_to(root_path)
			return false
		end
	end

end


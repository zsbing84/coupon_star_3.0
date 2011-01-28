# -*- encoding : utf-8 -*-
class CustomerSessionsController < ApplicationController
  trans_sid :always
	before_filter :require_mobile_request, :only => [:new]

  def new
		if signed_in_customer?
			redirect_to coupons_path
		else
			@customer_session = CustomerSession.new
		end
	end

	def create
		@customer_session = CustomerSession.new(params[:customer_session])
		if @customer_session.save
			flash[:notice] = "正常にログインしました。"
			redirect_back_or root_path
		else
			render :action => 'new'
		end
	end

	def destroy
		@customer_session = CustomerSession.find
		@customer_session.destroy
		flash[:notice] = "正常にログアウトしました。"
		redirect_to root_path
	end

end


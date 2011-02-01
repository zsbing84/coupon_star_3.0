# -*- encoding : utf-8 -*-
class MasterSessionsController < ApplicationController
	trans_sid
	before_filter :require_no_mobile_request, :only => [:new]

	def new
		if signed_in_master?
			redirect_to coupons_path
		else
			@master_session = MasterSession.new
		end
	end

	def create
    if signed_in_master?
      redirect_to coupons_path
    else
      @master_session = MasterSession.new(params[:master_session])
		  if @master_session.save
			  flash[:notice] = "正常にログインしました。"
			  redirect_back_or coupons_path
		  else
			  render :action => 'new'
		  end
    end
	end

	def destroy
		@master_session = MasterSession.find
		@master_session.destroy
		flash[:notice] = "正常にログアウトしました。"
		redirect_to master_signin_path
	end
end


# -*- encoding : utf-8 -*-
class CouponsController < ApplicationController
	trans_sid
	before_filter :require_no_mobile_request, :only => [:new, :create, :edit, :update, :destory, :analysis]
	before_filter :require_mobile_request, :only => [:show]
	before_filter :require_master, :only => [:new, :create, :update, :edit, :display_records]
  before_filter :require_correct_customer, :only => [:show]
	before_filter :require_master_or_customer, :only => [:index]
	before_filter :require_correct_coupon_master, :only => [:edit, :update, :destroy, :analysis]

	def index
		if admin_master?
			@title = "クーポン一覧"
		else
			@title = "マイクーポン"
		end
    if signed_in_master? && !request.mobile?
      @coupons = current_master.get_coupons
    elsif signed_in_customer? && request.mobile?
      @coupons = current_customer.get_coupons
      @count = @coupons.count
      @coupons = @coupons.paginate :page => params[:page], :order => 'updated_at DESC', :per_page => 10
    end

    @header_coupons = true
  end

	def show
		if request.mobile?
	    @coupon = Coupon.find(params[:id])
	    @title = @coupon.title
      current_customer.view(@coupon, Date.today)
		end
  end

  def edit
    @coupon = Coupon.find(params[:id])
    @title = @coupon.title
    @sub_header = true
    @coupon_general_info = true
    @header_coupons = true
  end

	def display_records
		@coupon = Coupon.find(params[:id])
		@records = @coupon.coupon_analysis_records
    @title = @coupon.title
    @header_coupons = true
    @sub_header = true
    @coupon_analysis_info = true

		render '/coupon_analysis_records/index'
	end

  def use
    @coupon = Coupon.find(params[:id])
    @result = current_customer.click(@coupon, Date.today)
  end

  def new
    @coupon = Coupon.new
    @title = "クーポン新規作成"
    @header_new_coupon = true
  end

  def create
		if params[:commit] == "有効にする"
      @coupon = Coupon.new(params[:coupon])
      if @coupon.save
				CouponAnalysisRecord.create!(:coupon_id => @coupon.id,
																:is_current => true,
																:name => "現在使用中")
        Coupon.activate!(@coupon, Date.today)
        flash[:success] = @coupon.title + "有効に設定されました"
        redirect_to edit_coupon_path(@coupon)
      else
      	@title = "クーポン作成"
        @header_new_coupon = true
    	  render 'new'
      end
    elsif params[:commit] == "新規作成"
      @coupon = Coupon.new(params[:coupon])
      if @coupon.save
        CouponAnalysisRecord.create!(:coupon_id => @coupon.id,
															 :is_current => true,
															 :name => "現在使用中")
        flash[:success] = @coupon.title + "が作成されました。"
        redirect_to coupons_path
      else
      	@title = "クーポン作成"
        @header_new_coupon = true
    	  render 'new'
      end
    end
  end

  def update
    @coupon = Coupon.find(params[:id])
    @title = @coupon.title
    @sub_header = true
    @coupon_general_info = true
    @header_coupons = true
    if params[:commit] == "有効にする"
      if @coupon.update_attributes(params[:coupon])
        Coupon.activate!(@coupon, Date.today)
        flash[:success] = @coupon.title + "が有効に設定されました。"
        redirect_to edit_coupon_path(@coupon)
      else
        render 'edit'
      end
    elsif params[:commit] == "無効にする"
      if Coupon.inactivate(@coupon)
				flash[:success] = @coupon.title + "が無効に設定されました。"
 				redirect_to edit_coupon_path(@coupon)
			else
        render 'edit'
			end

    elsif params[:commit] == "保存"
      if @coupon.update_attributes(params[:coupon])
        flash[:success] = @coupon.title + "が更新されました。"
        redirect_to edit_coupon_path(@coupon)
      else
        render 'edit'
      end
    end
  end

  def destroy
    coupon = Coupon.find(params[:id])
    coupon.destroy
    flash[:success] = coupon.title + "が削除されました。"
    redirect_to coupons_path
  end


end


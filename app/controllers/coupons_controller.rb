# -*- encoding : utf-8 -*-
class CouponsController < ApplicationController

	before_filter :require_no_mobile_request, :only => [:new, :create, :edit, :update, :destory, :analysis]
	before_filter :require_mobile_request, :only => [:show]
	before_filter :require_master, :only => [:new, :create]
  before_filter :require_correct_customer, :only => [:show]
	before_filter :require_master_or_customer, :only => [:index]
	before_filter :require_correct_coupon_master, :only => [:edit, :update, :destroy, :analysis]

	def index
    @title = "マイクーポン"
    if signed_in_master? && !request.mobile?
      @coupons = current_master.get_coupons
    elsif signed_in_customer? && request.mobile?
      @coupons = current_customer.get_coupons
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

  def analysis
    activated_at = nil
    record = nil
    general_id = nil

    if params[:commit] == "表示中レコード削除"
      record = CouponAnalysisRecord.find(params[:record_id])
      coupon = record.coupon
      record.destroy
      redirect_to analysis_coupon_path(coupon)
      return
    elsif params[:commit] == "レコード表示"
      record = CouponAnalysisRecord.find(params[:record_id])
      @coupon = record.coupon
      general_id = params[:general_id].to_i
      activated_at = record.activated_at
    else
      @coupon = Coupon.find(params[:id])
      record = CouponAnalysisRecord.where("coupon_id = ? AND is_current = ?", @coupon.id, true).first
      general_id = 1
      activated_at = record.activated_at
    end

    if !record.activated_at.nil?
      young_data = CouponAnalysisRecord.get_analysis_data(record, general_id, "young")
      prime_data = CouponAnalysisRecord.get_analysis_data(record, general_id, "prime")
      middle_data = CouponAnalysisRecord.get_analysis_data(record, general_id, "middle")
      old_data = CouponAnalysisRecord.get_analysis_data(record, general_id, "old")
      male_data = CouponAnalysisRecord.get_analysis_data(record, general_id, "male")
      female_data = CouponAnalysisRecord.get_analysis_data(record, general_id, "female")
      all_data = CouponAnalysisRecord.get_analysis_data(record, general_id, "all")
    else
      young_data = nil
      prime_data = nil
      middle_data = nil
      old_data = nil
      male_data = nil
      female_data = nil
      all_data = nil
    end

    @record = record
    @general = CouponChartDisplayGeneral.find(general_id)
    @title = @coupon.title
    @sub_header = true
    @coupon_analysis_info = true
    @header_coupons = true
		chart_y_title = get_chart_y_title(general_id)
    age_dist_title = get_age_dist_chart_title(general_id)
    gender_dist_title = get_gender_dist_chart_title(general_id)
    @age_dist_chart = get_coupon_age_dist_chart(
      age_dist_title, chart_y_title, activated_at, young_data, prime_data, middle_data, old_data, all_data)
    @gender_dist_chart = get_coupon_gender_dist_chart(
      gender_dist_title, chart_y_title, activated_at, male_data, female_data, all_data)
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

private

	def get_chart_y_title(general_id)
		if general_id == 1
      "閲覧数"
    elsif general_id == 2
      "利用数"
    end
	end

	def get_age_dist_chart_title(general_id)
		if general_id == 1
      "閲覧数遷移チャート　（年齢別）"
    elsif general_id == 2
      "利用数遷移チャート　（年齢別）"
    end
	end

	def get_gender_dist_chart_title(general_id)
		if general_id == 1
      "閲覧数遷移チャート　（男女別）"
    elsif general_id == 2
      "利用数遷移チャート　（男女別）"
    end
	end

end


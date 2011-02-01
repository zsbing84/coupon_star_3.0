# -*- encoding : utf-8 -*-

class CouponAnalysisRecordsController < ApplicationController
	trans_sid
	before_filter :require_no_mobile_request, :only => [:index, :destory]
	before_filter :require_master, :only => [:index, :destory]

  def destroy
    record = CouponAnalysisRecord.find(params[:id])
    @title = record.coupon.title
    @sub_header = true
    @coupon_analysis_info = true
    @header_coupons = true
		@coupon = record.coupon
		@records = record.coupon.coupon_analysis_records
    flash[:success] = record.name + "が削除されました。"
    record.destroy
		render '/coupon_analysis_records/index'
  end

	def show
    activated_at = nil
    record = nil
    general_id = nil

		if params[:commit] == "表示する"
		  general_id = params[:general_id].to_i
		else
		  general_id = 1
		end

		record = CouponAnalysisRecord.find(params[:id])
		activated_at = record.activated_at
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
		@coupon = record.coupon
    @general = CouponChartDisplayGeneral.find(general_id)
    @title = @record.coupon.title
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


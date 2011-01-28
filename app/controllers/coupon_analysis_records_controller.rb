# -*- encoding : utf-8 -*-

class CouponAnalysisRecordsController < ApplicationController
  def destroy
    record = CouponAnalysisRecord.find(params[:id])
    coupon = record.coupon
    record.destroy
    flash[:success] = record.name + " destroyed."
    redirect_to analysis_coupon_path(coupon)
  end
end


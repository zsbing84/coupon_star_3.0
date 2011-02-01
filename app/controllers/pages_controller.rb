# -*- encoding : utf-8 -*-
class PagesController < ApplicationController
	trans_sid

  def home
    if signed_in_master? || signed_in_customer?
      redirect_to coupons_path
    else
      if request.mobile?
        redirect_to customer_signin_path
      else
        redirect_to master_signin_path
      end
    end
  end
end


# -*- encoding : utf-8 -*-
class MasterActivationsController < ApplicationController

before_filter :require_no_master

  def create
    @master = Master.find_using_perishable_token(params[:activation_code], 1.hour) || (raise Exception)
    if @master.active?
      raise Exception
      return
    end

    if Master.activate!(@master)
      MasterSession.create(@master, false)
      MasterMailer.deliver_welcome_instructions(@master).deliver
      @header_coupons = true
      flash[:notice] = "登録が完了しました。"
      redirect_to coupons_path
    else
      render :action => :new
    end
  end

end


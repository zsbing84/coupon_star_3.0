# -*- encoding : utf-8 -*-
class MasterActivationsController < ApplicationController

before_filter :require_no_master

  def create
    @master = Master.find_using_perishable_token(params[:activation_code], 1.week) || (raise Exception)
    raise Exception if @master.active?

    if Master.activate!(@master)
      flash[:notice] = "Your account has been activated!"
      MasterSession.create(@master, false) # Log master in manually
      MasterMailer.deliver_welcome_instructions(@master).deliver
      redirect_to root_path
      @header_coupons = true
    else
      render :action => :new
    end
  end

end


# -*- encoding : utf-8 -*-
class CustomerActivationsController < ApplicationController

before_filter :require_no_customer

  def create
    @customer = Customer.find_using_perishable_token(params[:activation_code], 1.week) || (raise Exception)
    raise Exception if @customer.active?

    if Customer.activate!(@customer)
      flash[:notice] = "Your account has been activated!"
      CustomerSession.create(@customer, false) # Log master in manually
      CustomerMailer.deliver_welcome_instructions(@customer).deliver 
      redirect_to root_path
    else
      render :action => :new
    end
  end

end

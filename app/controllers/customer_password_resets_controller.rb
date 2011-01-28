class CustomerPasswordResetsController < ApplicationController
  before_filter :load_customer_using_perishable_token, :only => [:edit, :update]
  before_filter :require_no_customer
  
  def new
    render
  end
  
  def create
    @customer = Customer.find_by_email(params[:email])
    if @customer
			@customer.reset_perishable_token!
      CustomerMailer.delay.deliver_password_reset_instructions!(@customer)
      flash[:notice] = "Instructions to reset your password have been emailed to you. " +
        "Please check your email."
      redirect_to root_path
    else
      flash[:notice] = "No customer was found with that email address"
      render 'new'
    end
  end
  
  def edit
    render
  end

  def update
    @customer.password = params[:customer][:password]
    @customer.password_confirmation = params[:customer][:password_confirmation]
    if @customer.save
      flash[:notice] = "Password successfully updated"
      redirect_to root_path
    else
      render 'edit'
    end
  end

private

  def load_customer_using_perishable_token
    @customer = Customer.find_using_perishable_token(params[:id])
    unless @customer
      flash[:notice] = "We're sorry, but we could not locate your account." +
        "If you are having issues try copying and pasting the URL " +
        "from your email into your browser or restarting the " +
        "reset password process."
      redirect_to root_path
    end
  end
end

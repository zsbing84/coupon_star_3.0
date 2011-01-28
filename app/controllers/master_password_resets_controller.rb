class MasterPasswordResetsController < ApplicationController
  before_filter :load_master_using_perishable_token, :only => [:edit, :update]
  before_filter :require_no_master
  
  def new
    render
  end
  
  def create
    @master = Master.find_by_email(params[:email])
    if @master
			@master.reset_perishable_token!
      MasterMailer.delay.deliver_password_reset_instructions!(@master)
      flash[:notice] = "Instructions to reset your password have been emailed to you. " +
        "Please check your email."
      redirect_to root_path
    else
      flash[:notice] = "No master was found with that email address"
      render 'new'
    end
  end
  
  def edit
    render
  end

  def update
    @master.password = params[:master][:password]
    @master.password_confirmation = params[:master][:password_confirmation]
    if @master.save
      flash[:notice] = "Password successfully updated"
      redirect_to root_path
    else
      render 'edit'
    end
  end

private

  def load_master_using_perishable_token
    @master = Master.find_using_perishable_token(params[:id])
    unless @master
      flash[:notice] = "We're sorry, but we could not locate your account." +
        "If you are having issues try copying and pasting the URL " +
        "from your email into your browser or restarting the " +
        "reset password process."
      redirect_to root_path
    end
  end
end

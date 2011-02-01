# -*- encoding : utf-8 -*-
class MasterPasswordResetsController < ApplicationController
	trans_sid
	before_filter :require_no_master, :only => [:new]

  def new
    render
  end

  def create
    @master = Master.find_by_email(params[:email])
    if @master
      password = @master.new_random_password
      @master.update_attributes(:password => password,
                                :password_confirmation => password)
      MasterMailer.delay.deliver_password_reset_instructions(@master, password)
		  @master_session = MasterSession.find
		  @master_session.destroy
      flash[:notice] = "#{@master.email}宛に仮パスワードを送信しました。ログイン後、パスワードを再設定して下さい。"
		  redirect_to master_signin_path
    else
      flash[:notice] = "ご入力されたのメールアドレスが登録されていません。"
      render 'new'
    end
  end

end


# -*- encoding : utf-8 -*-
class MasterMailer < ActionMailer::Base
  
  def deliver_activation_instructions(master)  
  	@master = master 
  	@url = activate_url(master.perishable_token)
  	mail(:to => master.email,  :subject => "【グルーポン(COUPONSTAR)】仮登録受付メール")  
  end 
  
  def deliver_welcome_instructions(master)  
  	@master = master 
  	mail(:to => master.email,  :subject => "【グルーポン(COUPONSTAR)】ご登録ありがとうございました。")  
  end 

  def deliver_password_reset_instructions(master)
  	@master = master
		@edit_master_password_reset_url = edit_master_password_reset_url(master.perishable_token)
  	mail(:to => master.email,  :subject => "【グルーポン(COUPONSTAR)】パスワード再発行を受付しました。")
  end

  
private
	def activate_url(activation_code)
		"http://localhost:3000/master_activate/#{activation_code}"
	end

end

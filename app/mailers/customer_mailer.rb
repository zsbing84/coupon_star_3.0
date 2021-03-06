# -*- encoding : utf-8 -*-
class CustomerMailer < ActionMailer::Base
  default :from => "notifications@example.com"

  def deliver_activation_instructions(customer)
  	@customer = customer
  	@url = activate_url(customer.perishable_token)
  	mail(:to => customer.email,  :subject => "【グルーポン(COUPONSTAR)】仮登録受付メール")
  end

  def deliver_welcome_instructions(customer)
  	@customer = customer
  	mail(:to => customer.email,  :subject => "【グルーポン(COUPONSTAR)】ご登録ありがとうございました。")
  end

  def deliver_new_coupon_instructions(customer, coupon)
  	@customer = customer
  	@coupon = coupon
  	mail(:to => customer.email,  :subject => "【グルーポン(COUPONSTAR)】新しいクーポンのお知らせ。")
  end

  def deliver_password_reset_instructions(customer)
  	@customer = customer
		@url = edit_customer_password_reset_url(customer.perishable_token)
  	mail(:to => customer.email,  :subject => "【グルーポン(COUPONSTAR)】パスワードを再発行しました。")
  end

private
	def activate_url(activation_code)
		"http://localhost:3000/customer_activate/#{activation_code}"
	end

end


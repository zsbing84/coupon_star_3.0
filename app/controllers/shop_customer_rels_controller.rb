class ShopCustomerRelsController < ApplicationController

	def create
    @shop = Shop.find(params[:shop_customer_rel][:shop_id])
    current_customer.follow!(@shop, Date.today)
    respond_to do |format|
      format.html { redirect_to @shop }
      format.js
    end
  end

  def destroy
    @shop = ShopCustomerRel.find(params[:id]).shop
    current_customer.unfollow!(@shop, Date.today)
    respond_to do |format|
      format.html { redirect_to @shop }
      format.js
    end
  end

end


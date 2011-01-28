# -*- encoding : utf-8 -*-
class CustomerSession < Authlogic::Session::Base  

	include ActiveModel::Conversion
  def persisted?
    false
  end 
  
end

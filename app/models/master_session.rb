# -*- encoding : utf-8 -*-
class MasterSession < Authlogic::Session::Base

	include ActiveModel::Conversion
  def persisted?
    false
  end

end


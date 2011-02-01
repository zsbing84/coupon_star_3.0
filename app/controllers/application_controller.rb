# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery :secret
  include CouponsHelper
  include ShopsHelper
  include MasterSessionsHelper
  include CustomerSessionsHelper

end


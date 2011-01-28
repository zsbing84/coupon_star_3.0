# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery
  include CouponsHelper
  include ShopsHelper
  include MasterSessionsHelper
  include CustomerSessionsHelper

end


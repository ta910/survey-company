class SurveysController < ApplicationController

  before_action :authenticate_admin_or_user

  def index

  end

end

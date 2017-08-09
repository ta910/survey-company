class SurveysController < ApplicationController
  before_action :authenticate_user!, :authorized_user!
end

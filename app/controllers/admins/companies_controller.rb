class Admins::CompaniesController < AdminsController

  def index
    @companies = Company.all
  end

  def search
    @companies = Company.where('name LIKE ?', "%#{params[:name]}%")
    respond_to do |format|
      format.json { render json: @companies }
    end
  end

end

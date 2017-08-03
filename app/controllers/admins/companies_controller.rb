class Admins::CompaniesController < AdminsController

  def index
    @companies = Company.all
  end

  def new
    @company = Company.new
    @company.users.build
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      @company.users.last.main!
      redirect_to admins_companies_path
    else
      render :new
    end
  end

  def edit
    @company = company
  end

  def update
    
  end

  def delete
    
  end

  def search
    @companies = Company.where('name LIKE ?', "%#{params[:name]}%")
    respond_to do |format|
      format.json { render json: @companies }
    end
  end

  private

  def company_params
    params.require(:company).permit(:name, users_attributes: [:id, :name, :email, :password, :password_confirmation])
  end

  def company
    Company.find_by(name: params[:name])
  end

end

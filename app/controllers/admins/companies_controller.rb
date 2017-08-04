class Admins::CompaniesController < AdminsController

  def index
    @companies = Company.order("created_at DESC").page(params[:page]).per(5)
  end

  def new
    @company = Company.new
    @user = @company.users.build
  end

  def create
    @company = Company.new(company_params)
    begin
      ActiveRecord::Base.transaction do
        @company.save!
        @company.users.last.main!
      end
      redirect_to admins_companies_path
    rescue
      render :new
    end
  end

  def edit
    @company = company
    @user = company.main_user!
  end

  def update
    @company = company
    @user = user
    begin
      ActiveRecord::Base.transaction do
        company.update!(company_params)
        user.update!(user_params)
      end
      redirect_to admins_companies_path
    rescue ActiveRecord::RecordInvalid
      render :edit
    end
  end

  def destroy
    company.destroy
    redirect_to admins_companies_path
  end

  def search
    @companies = Company.where('name LIKE ?', "%#{params[:name]}%")
    respond_to do |format|
      format.json { render json: @companies }
    end
  end

  private

  def company_params
    params.require(:company).permit(:name, users_attributes: [:name, :email, :password, :password_confirmation])
  end

  def user_params
    params.require(:company).require(:user).permit(:name, :email, :password, :password_confirmation, :user_id)
  end

  def company
    Company.find_by!(name: params[:name])
  end

  def user
    User.find(user_params[:user_id])
  end

end

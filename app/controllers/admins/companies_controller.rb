class Admins::CompaniesController < AdminsController
  def index
    @companies = Company.order(created_at: 'DESC').page(index_params[:page]).per(index_params[:per])
  end

  def new
    @company = Company.new
    @user = User.new
  end

  def create
    Company.create_with_main_user!(company_name: company_params[:name], user_name: user_params[:name],
       email: user_params[:email], password: user_params[:password],
        password_confirmation: user_params[:password_confirmation])
    redirect_to admins_companies_path
  rescue
    @company = Company.new
    @user = User.new
    render :new
  end

  def edit
    @company = company
    @user = company.main_user
  end

  def update
    company.update_with_main_user!(company_name: company_params[:name], user_name: user_params[:name],
       email: user_params[:email], password: user_params[:password],
        password_confirmation: user_params[:password_confirmation])
    redirect_to admins_companies_path
  rescue ActiveRecord::RecordInvalid
    @company = company
    @user = user
    render :edit
  end

  def destroy
    company.destroy!
    redirect_to admins_companies_path
  end

  def search
    @companies = Company.where('name LIKE ?', "%#{params[:name]}%")
    respond_to do |format|
      format.json { render json: @companies }
    end
  end

  private

    def index_params
      @index_params = params.permit(:page, :per)
      @index_params[:per] ||= 10
      @index_params
    end

    def company_params
      params.require(:company).permit(:name)
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

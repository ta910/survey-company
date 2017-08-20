class MessagesController < ApplicationController
  before_action :authenticate_user!, :authorized_user!
  before_action :validate_user!, only: :index

  def index
    @message = Message.new
    @user = user
    @users = current_user.company.normal_users
    @messages = messages
  end

  def create
    @message = Message.create_text_or_image!(text: message_params[:text], image: message_params[:image],
      sender_id: current_user.id, recipient_id: recipient_id)
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render json: @message.for_js }
    end
  rescue
    @user = user
    @users = current_user.company.users
    @messages = messages
    render :index
  end

  private

    def message_params
      params.require(:message).permit(:text, :image)
    end

    def recipient_id
      if current_user.main?
        user.id
      else
        current_user.company.main_user.id
      end
    end

    def company
      Company.find_by!(params[:name])
    end

    def user
      User.find(params[:user_id])
    end

    def messages
      Message.includes([:sender, :message_text, :message_image]).
        where(sender_id: user.id).or(Message.includes([:sender, :message_text, :message_image]).
          where(recipient_id: user.id))
    end
end

class MessagesController < ApplicationController
  before_action :set_instance, only: [:index, :create]

  def index
    @message = Message.new
  end

  def create
    @message = Message.new(body: message_params[:body], image: message_params[:image],
      sender_id: message_params[:sender_id], recipient_id: message_params[:recipient_id])
    if @message.save
      respond_to do |format|
        format.html { redirect_to :back }
        format.json
      end
    else
      render :index
    end
  end

  private

    def message_params
      params.require(:message).permit(:body, :image).
        merge(sender_id: current_user.id, recipient_id: recipient_id)
    end

    def recipient_id
      if current_user.main?
        user.id
      else
        current_user.company.main_user.id
      end
    end

    def set_instance
      @user = user
      @messages = messages
    end

    def company
      Company.find_by!(params[:name])
    end

    def user
      User.find(params[:user_id])
    end

    def messages
      Message.includes(:sender).
        where('sender_id = ? OR recipient_id = ?', user.id, user.id)
    end
end

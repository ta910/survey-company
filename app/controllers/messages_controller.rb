class MessagesController < ApplicationController
  def index
    @message = Message.new
    @user = user
    @messages = messages
  end

  def create
    @message = Message.new(body: message_params[:body], image: message_params[:image],
      sender_id: current_user.id, recipient_id: recipient_id)
    if @message.save
      respond_to do |format|
        format.html { redirect_to :back }
        format.json
      end
    else
      @user = user
      @messages = messages
      render :index
    end
  end

  private

    def message_params
      params.require(:message).permit(:body, :image)
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
      Message.includes(:sender).
        where(sender_id: user.id).or(Message.includes(:sender).
          where(recipient_id: user.id))
    end
end

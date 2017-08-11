class MessagesController < ApplicationController
  def index
    @message = current_user.messages.new
    @messages = Message.includes(:user)
  end

  def create
    @message = current_user.messages.new(message_params)
    if @message.save
      respond_to do |format|
        format.html { redirect_to
           company_user_messages_path(@message.user.company.name, @message.user) }
        format.json
      end
    else
      render :index
    end
  end

  private

    def message_params
      params.require(:message).permit(:body, :image)
    end

    def company
      Company.find_by!(params[:name])
    end
end

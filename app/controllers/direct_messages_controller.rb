class DirectMessagesController < ApplicationController
  before_action :set_initial_params, only: [:index, :create]

  def index
    @direct_message = DirectMessage.new
  end

  def create
    @direct_message = current_user.sent_messages.build(direct_message_params)
    @direct_message.receiver_id = params[:user_id]
    if @direct_message.save
      redirect_to user_direct_messages_path(params[:user_id])
    else
      render :index
    end
  end

  private

  def direct_message_params
    params.require(:direct_message).permit(:content)
  end

  def set_initial_params
    @direct_messages = DirectMessage.where("sender_id = ? AND receiver_id = ?", current_user.id, params[:user_id])
                                    .or(DirectMessage.where("sender_id = ? AND receiver_id = ?", params[:user_id], current_user.id))
                                    .order(:created_at)
    @user = User.find(params[:user_id])
  end
end

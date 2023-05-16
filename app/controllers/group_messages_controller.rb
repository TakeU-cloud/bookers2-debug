class GroupMessagesController < ApplicationController
  def new
    @group = Group.find(params[:group_id])
    @group_message = @group.group_messages.build
  end

  def create
    @group = Group.find(params[:group_id])
    @group_message = @group.group_messages.build(group_message_params)
    if @group_message.save
      redirect_to group_group_message_path(@group, @group_message), notice: '送信が完了しました'
    else
      render :new
    end
  end

  def show
    @group = Group.find(params[:group_id])
    @group_message = GroupMessage.find(params[:id])
  end

  def index
    redirect_to new_group_group_message_path
  end

  private

  def group_message_params
    params.require(:group_message).permit(:title, :content)
  end
end

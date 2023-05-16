class GroupsController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

  def index
    @groups = Group.all
    @book = Book.new
  end

  def show
    @group = Group.find(params[:id])
    @user = @group.owner
    @book = Book.new
  end

  def new
    @group = Group.new
  end

  def create
    @group = current_user.owned_groups.build(group_params)
    if @group.save
      redirect_to groups_path, notice: 'Group was successfully created.'
    else
      render :new
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path, notice: "You have updated group successfully."
    else
      render :edit
    end
  end

  private

  def group_params
    params.require(:group).permit(:name, :introduction, :group_image)
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
    @user = @group.owner
    unless @user == current_user
      redirect_to groups_path
    end
  end
end

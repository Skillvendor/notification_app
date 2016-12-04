class GroupsController < ApplicationController
  before_action :check_role
  before_action :set_group, only: [:show, :edit, :update, :destroy, :members, :delete_member, :add_members, :add_member]

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.all
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def members
    @members = User.joins(:memberships).where("members.group_id = ?", @group.id)
  end

  def delete_member
    Member.where(user_id: params[:user_id], group_id: @group.id).first.destroy
    respond_to do |format|
      format.html { redirect_to members_group_url(@group), notice: 'Member was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def add_members
    @users = User.joins('LEFT JOIN members on users.id = members.user_id').where('members.group_id IS NULL')
  end

  def add_member
    @user = User.find(params[:user_id])
    @user.memberships.create(group_id: @group.id)
    respond_to do |format|
      format.html { redirect_to add_members_group_url(@group), notice: "#{@user.first_name} is now a member" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    def check_role
      unless current_admin && (current_admin.role == 'Master' || current_admin.role == 'Admin')
        redirect_to root_path
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, :description)
    end
end

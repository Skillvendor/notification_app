class GroupsController < ApplicationController
  before_action :check_role
  before_action :set_group, only: [:show, :edit, :update, :destroy, :members, :delete_member, :add_members, :add_member, :bulk_add]

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
    @users = User.where("users.id NOT IN (select members.user_id from members where members.group_id = ?)", params[:id])

    if params[:first_name] && params[:first_name].present?
      @users = @users.where(first_name: params[:first_name])
    end

    if params[:last_name] && params[:last_name].present?
      @users = @users.where(last_name: params[:last_name])
    end

    if params[:serie] && params[:serie].present?
      @users = @users.where('groups @> ?', '[{ "serie":' + params[:serie].to_s + ' }]' )
    end

    if params[:year] && params[:year].present?
      @users = @users.where('groups @> ?', '[{ "year":' + params[:year].to_s + ' }]' )
    end

    if params[:group_number] && params[:group_number].present?
      @users = @users.where('groups @> ?', '[{ "group_number":' + params[:group_number].to_s + ' }]' )
    end

    if params[:group] && params[:group].present?
      @users = @users.joins(:memberships).where('members.group_id = ?', params[:group])
    end

    @series = []
    @years = []
    @group_numbers = []
    User.all.find_in_batches(batch_size: 500).each do |batch|
      batch.each do |user|
        user.groups.each do |user_hash|
          @series << user_hash['serie']
          @years << user_hash['year']
          @group_numbers << user_hash['group_number']
        end
      end
    end

    @series = @series.uniq
    @years = @years.uniq
    @group_numbers = @group_numbers.uniq
  end

  def bulk_add
    @users = User.where("users.id NOT IN (select members.user_id from members where members.group_id = ?)", params[:id])

    if params[:first_name] && params[:first_name].present?
      @users = @users.where(first_name: params[:first_name])
    end

    if params[:last_name] && params[:last_name].present?
      @users = @users.where(last_name: params[:last_name])
    end

    if params[:serie] && params[:serie].present?
      @users = @users.where('groups @> ?', '[{ "serie":' + params[:serie].to_s + ' }]' )
    end

    if params[:year] && params[:year].present?
      @users = @users.where('groups @> ?', '[{ "year":' + params[:year].to_s + ' }]' )
    end

    if params[:group_number] && params[:group_number].present?
      @users = @users.where('groups @> ?', '[{ "group_number":' + params[:group_number].to_s + ' }]' )
    end

    if params[:group] && params[:group].present?
      @users = @users.joins(:memberships).where('members.group_id = ?', params[:group])
    end

   @users.find_in_batches(batch_size: 500).each do |batch|
      batch.each do |user|
        user.memberships.create(group_id: @group.id)
      end
    end

    respond_to do |format|
      format.html { redirect_to add_members_group_url(@group), notice: "All the users are now members of #{@group.name}" }
      format.json { head :no_content }
    end
  end

  def add_member
    @user = User.find(params[:user_id])
    @user.memberships.create(group_id: @group.id)
    respond_to do |format|
      format.html { redirect_to add_members_group_url(@group), notice: "#{@user.first_name} is now a member of #{@group.name}" }
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

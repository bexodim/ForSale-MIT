class UsersController < ApplicationController
  ## handles how to show user information, including bag ##
  ## and room information.  creates and deletes users.   ##
  
  
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
	@user = User.find(params[:id])
	i = Item.check_timeout() ##checks if item has timedout and should be unclaimed
	
	unless session[:user_id] == @user.id ### current user can only visit its own page
      flash[:notice] = "You don't have access to that page!"
      redirect_to user_path(session[:user_id])
      return
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new
    @room = @user.build_room
    @bag = @user.build_bag
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    unless session[:user_id] == @user.id ## current user can only edit its own information
      flash[:notice] = "You don't have access to that page!"
      redirect_to user_path(session[:user_id])
      return
    end
  end

  # POST /users
  # POST /users.json
  def create
    ## creating a new user also creates the relative bag and room ##
    @user = User.new(params[:user])
	
    respond_to do |format|
      if @user.save
		@room = Room.new(params[:room])
		@room.update_attributes(:kerberos => @user.kerberos, :user_id => @user.id) ## room
		@bag = Bag.new(params[:bag])
		@bag.update_attributes(:kerberos => @user.kerberos, :user_id => @user.id) ## bag
		session[:user_id] = @user.id
		if @room.save && @bag.save
			format.html { redirect_to login_path, notice: 'User was successfully created.' }
			format.json { render json: @user, status: :created, location: @user }
		else
			format.html { render action: "new" }
			format.json { render json: @user.errors, status: :unprocessable_entity }
		end
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])
    unless session[:user_id] == @user.id
      flash[:notice] = "You don't have access to that page!"
      redirect_to user_path(session[:user_id])
      return
    end

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    unless session[:user_id] == @user.id
      flash[:notice] = "You don't have access to that page!"
      redirect_to user_path(session[:user_id])
      return
    end
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
  
  # GET /users/1/bag
  # GET /users/1/bag.json
  def bag
    ## shows items that have been added to the bag in view ##
	@user = current_user
	i = Item.check_timeout() ##checks if item has timedout and should be unclaimed

    respond_to do |format|
      format.html # bag.html.erb
      format.json { render json: @user }
    end
  end
  
  # GET /users/1/room
  # GET /users/1/room.json
  def room
    ## shows items user has created in room, in the view ##
	@user = current_user
	i = Item.check_timeout() ##checks if item has timedout and should be unclaimed

    respond_to do |format|
      format.html # room.html.erb
      format.json { render json: @user }
    end
  end
  
  
  ### not needed now. for a later feature ###
  #def history
	#@bag_id = Bag.where(:user_id => current_user.id).first.id
	#@room_id = Room.where(:user_id => current_user.id).first.id
	#@sold = Items.where(:room_id => @room_id) 
  #end
end

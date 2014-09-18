class ItemsController < ApplicationController
  #provides methods to add, delete, edit and show items, as well as
  #changing statuses based on the current user's actions.
  
  
  # GET /items
  # GET /items.json
  def index
    @items = Item.all
    i = Item.check_timeout() ##checks if item has timedout and should be unclaimed

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @items }
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @item = Item.find(params[:id])
    i = Item.check_timeout()
    
    ## checks if user should be seeing this item and directs back to dormroom page
	if @item.status == 'bought' && @item.bag_id != session[:user_id] && @item.room_id != session[:user_id]
	  flash[:notice] = "This item is no longer available."
      redirect_to items_path
      return
	end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item }
    end
  end

  # GET /items/new
  # GET /items/new.json
  def new
    @item = Item.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @item }
    end
  end

  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
    
    ## checks if item is still editable and if the user owns the item, redirects to user dormroom page
    unless @item.room_id == session[:user_id] && @item.status == 'active'
	  flash[:notice] = "You don't have access to that page!"
      redirect_to user_path(session[:user_id])
      return
	end
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(params[:item])
    
    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render json: @item, status: :created, location: @item }
      else
        format.html { render action: "new" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PUT /items/1
  # PUT /items/1.json
  def update
    @item = Item.find(params[:id])

    respond_to do |format|
      if @item.update_attributes(params[:item])
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /items/1/addto
  # GET /items/1/addto.json
  def addto
	@bag = Bag.where(:user_id => current_user.id).first
	@item = Item.find(params[:id])
	@bag.items << @item ## given item, adds to current users bag
    respond_to do |format|
      if @bag.save
		@item.update_attribute(:status, 'claimed')
        format.html { redirect_to bag_path(current_user), notice: 'Item was successfully added to your bag.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # GET /items/1/removefrom
  # GET /items/1/removefrom.json
  def removefrom
	@bag = Bag.where(:user_id => current_user.id).first
	@item = Item.find(params[:id])
	@bag.items.delete(@item)
    respond_to do |format|
      if @bag.save
		@item.update_attribute(:status, 'active')
        format.html { redirect_to bag_path(current_user), notice: 'Item was successfully deleted from your bag.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end
  
## currently no photos being added or removed ##
  #def removephoto
	#@item = Item.find(params[:id])
	#@item.photo.destroy
	#if @item.save
		#respond_to do |format|
		  #format.html { redirect_to edit_item_path(@item), notice: 'Checkout successful!' }
		  #format.json { head :no_content }
		#end
	#end
  #end
#####################################
  
  
  # GET /checkout
  # GET /checkout.json
  def checkout
  ### eventually will send an email or something ###
  ## currently just adds item to your bought list ##
	current_bag.items.each do |item|
		item.update_attribute(:status,'bought')
	end
	respond_to do |format|
      format.html { redirect_to user_path(current_user), alert: 'Checkout successful!' }
      format.json { head :no_content }
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to user_path(current_user) }
      format.json { head :no_content }
    end
  end

end

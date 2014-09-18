class Item < ActiveRecord::Base
  belongs_to :room
  belongs_to :bag
  attr_accessible :description, :photo, :name, :price, :price, :status, :room_id, :bag_id, :photo_file_name, :photo_content_type, :photo_file_size
  
  validates :name, :presence => true
  validates :price, :presence => true
  validates :room_id, :presence => true

  attr_accessor :photo_file_name
  attr_accessor :photo_content_type
  attr_accessor :photo_file_size
  attr_accessor :photo_updated_at
  
  ### PICTURE UPLOADS ###
  ### no photos being added or removed currently ##
  has_attached_file :photo, :styles => { :thumb=> "100x100#",
										:standard  => "400x400>" },
							:url  => "/assets/items/:id/:style/:basename.:extension",
							:path => ":rails_root/public/assets/items/:id/:style/:basename.:extension"

  #validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 15.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
  ########################
  
  ### checks which items are now unclaimed ###
  def self.check_timeout()
	Item.all.each do |item|
		update = Time.now.utc - item.updated_at.utc
		if item.status == 'claimed' && update > 3600 ## becomes unclaimed after an hour
			item.update_attributes(:status => 'active')
			@bag = Bag.find(item.bag_id)
			@bag.items.delete(item)
			
		end 
	end
  end
end

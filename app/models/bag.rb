class Bag < ActiveRecord::Base
  belongs_to :user
  has_many :items
  attr_accessible :kerberos, :user_id
  
  validates :user_id, :presence => true ## must have a user associated with it
  ## but items can be added later
end

class User < ActiveRecord::Base
  attr_accessible :kerberos, :password, :password_confirmation
  has_one :room, :foreign_key => 'user_id', :dependent => :nullify ## Every user must have a bag and room
  has_one :bag, :foreign_key => 'user_id', :dependent => :nullify  ## associated with it, to buy and sell.
  has_many :items, :through => :room
  has_many :items, :through => :bag
  
  validates :kerberos, :presence => true
  validates :password, :presence => true
  
  before_save :encrypt_password
  after_save :clear_password 
  

  def self.authenticate(kerberos, password)
    u = User.where(:kerberos => kerberos).first
    if u && u.password_hash == BCrypt::Engine.hash_secret(password, u.password_salt)
      return u
    else
      return nil
    end
  end
  
  def encrypt_password
	if password.present?
		self.password_salt = BCrypt::Engine.generate_salt
		self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
	end
  end
  
  def clear_password
	self.password = nil
  end

end

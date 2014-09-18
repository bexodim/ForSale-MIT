require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  ###no kerberos or password
  test "should not save user without kerberos or password" do
	user = User.new
	assert !user.save 
  end
  
  ###user has a room
  test "user has a room" do
	user = User.create(:kerberos => 'testuser', :password => 'testuser')
	assert_not_nil Room.where(:user_id => user.id)
  end
  
  ###user has a bag
  test "user has a bag" do
	user = User.create(:kerberos => 'testuser', :password => 'testuser')
	assert_not_nil Bag.where(:user_id => user.id)
  end
  
  ###no duplicate kerberos
  test "no duplicate kerberos" do
	user1 = User.create(:kerberos => 'brandy', :password => 'rayj')
	user2 = User.create(:kerberos => 'brandy', :password => 'moesha')
	assert(!user2.valid?)
  end
end

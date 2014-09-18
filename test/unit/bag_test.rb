require 'test_helper'

class BagTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  ###no bag with a user
  test "no bag without user" do
	bag = Bag.new
	assert !bag.save
  end
end

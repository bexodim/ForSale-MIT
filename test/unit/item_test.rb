require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  ###item without attributes cannot be saved
  test "item missing all attributes" do
	item = Item.new
	assert !item.save
  end
  
  
end

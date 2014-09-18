require 'test_helper'

class RoomTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  ###no room without user
  test "no room without user" do
	room = Room.new
	assert !room.save
  end
end

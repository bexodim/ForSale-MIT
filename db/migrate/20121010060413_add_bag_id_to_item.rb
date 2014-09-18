class AddBagIdToItem < ActiveRecord::Migration
  def change
    add_column :items, :bag_id, :integer
  end
end

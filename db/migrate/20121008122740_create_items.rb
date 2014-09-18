class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.references :room
      t.string :status
      t.string :name
      t.decimal :price, :precision => 7, :scale => 2
      t.text :description
      t.string :image

      t.timestamps
    end
    add_index :items, :room_id
  end
end

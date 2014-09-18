class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :kerberos
      t.references :user

      t.timestamps
    end
    add_index :rooms, :user_id
  end
end

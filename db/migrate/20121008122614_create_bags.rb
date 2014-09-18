class CreateBags < ActiveRecord::Migration
  def change
    create_table :bags do |t|
      t.string :kerberos
      t.references :user

      t.timestamps
    end
    add_index :bags, :user_id
  end
end

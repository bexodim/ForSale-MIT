class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :kerberos
      t.string :password
      t.string :password_hash
      t.string :password_salt

      t.timestamps
    end
  end
end

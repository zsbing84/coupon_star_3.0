# -*- encoding : utf-8 -*-
class CreateMasters < ActiveRecord::Migration
  def self.up
    create_table :masters do |t|
      t.string :email, :null => false
      t.boolean :admin, :null => false, :default => false
      t.boolean :active, :null => false, :default => false
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token
      t.string :perishable_token

      t.timestamps
    end
  end

  def self.down
    drop_table :masters
  end
end


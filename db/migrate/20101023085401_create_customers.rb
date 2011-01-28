# -*- encoding : utf-8 -*-
class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
      t.string :email, :null => false
      t.boolean :active, :null => false, :default => false
      t.boolean :receive_notice, :null => false, :default => true
      t.date :birthday
      t.integer :age
      t.integer :gender_id
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token
      t.string :perishable_token

      t.timestamps
    end
  end

  def self.down
    drop_table :customers
  end
end


# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[7.0]
  def up
    drop_table :users, if_exists: true do |t|
      t.string :first_name
      t.string :last_name
      t.string :password  
      t.string :confirm_password
      t.boolean :active
      t.integer :role

      t.timestamps 
    end
  end

  def down
    create_table :users, if_not_exists: true do |t|
      t.string :first_name
      t.string :last_name
      t.string :password  
      t.string :confirm_password
      t.boolean :active
      t.integer :role

      t.timestamps 
    end


  end
end

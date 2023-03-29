class CreateTableUser < ActiveRecord::Migration[7.0]
  def change
    create_table :table_users do |t|

      t.timestamps
    end
  end
end

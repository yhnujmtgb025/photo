class CreateAlbums < ActiveRecord::Migration[7.0]
  def change
    create_table :albums do |t|
      t.belongs_to :user

      t.string :title
      t.string :desc
      t.boolean :state

      t.timestamps
    end

  end
end

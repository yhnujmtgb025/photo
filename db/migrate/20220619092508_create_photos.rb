class CreatePhotos < ActiveRecord::Migration[7.0]
  def change
    create_table :photos do |t|
      t.belongs_to :user

      t.integer :album_id
      t.string :title
      t.string :desc
      t.string :file
      t.string :state

      t.timestamps
    end
  end
end

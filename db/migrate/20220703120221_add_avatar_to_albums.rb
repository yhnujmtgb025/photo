class AddAvatarToAlbums < ActiveRecord::Migration[7.0]
  def change
    add_column :albums, :avatar, :string
  end
end

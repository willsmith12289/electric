class RemoveImageUrlFromProducts < ActiveRecord::Migration
  def change
    remove_column :products, :image_url, :string
    add_column :products, :image, :string
  end
end

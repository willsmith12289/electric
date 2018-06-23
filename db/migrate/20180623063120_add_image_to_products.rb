class AddImageToProducts < ActiveRecord::Migration
  def change
    remove_column :products, :image, :string
    add_column :products, :image, :json
  end
end

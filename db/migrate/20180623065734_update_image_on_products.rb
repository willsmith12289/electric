class UpdateImageOnProducts < ActiveRecord::Migration
  def change
    remove_column :products, :image, :json
    add_column :products, :image, :string
  end
end

class AddDiscountToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :discount, :integer
  end
end

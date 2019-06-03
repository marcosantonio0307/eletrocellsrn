class AddCategoryToSales < ActiveRecord::Migration[5.2]
  def change
    add_column :sales, :category, :string
    add_column :sales, :description, :string
    add_column :sales, :status, :string
  end
end

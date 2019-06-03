class AddNextbeginToCash < ActiveRecord::Migration[5.2]
  def change
    add_column :cashes, :next_begin, :decimal
  end
end

class CreateExpenses < ActiveRecord::Migration[5.2]
  def change
    create_table :expenses do |t|
      t.string :category
      t.decimal :total
      t.string :description

      t.timestamps
    end
  end
end

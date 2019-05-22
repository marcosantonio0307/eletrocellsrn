class CreateSales < ActiveRecord::Migration[5.2]
  def change
    create_table :sales do |t|
      t.references :client, foreign_key: true
      t.references :user, foreign_key: true
      t.decimal :total

      t.timestamps
    end
  end
end

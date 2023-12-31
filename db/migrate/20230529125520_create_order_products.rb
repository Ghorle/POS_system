class CreateOrderProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :order_products do |t|
      t.string :name
      t.references :order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.string :description
      t.float :price
      t.integer :qty
      t.float :tax
      t.string :tax_type

      t.timestamps
    end
  end
end

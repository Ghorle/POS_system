class CreateRawMaterials < ActiveRecord::Migration[6.0]
  def change
    create_table :raw_materials do |t|
      t.string :name
      t.decimal :quantity, precision: 10, scale: 2
      t.timestamps
    end
    create_table :ingredients do |t|
      t.references :product, null: false, foreign_key: true
      t.references :raw_material, null: false, foreign_key: true
      t.decimal :quantity, precision: 10, scale: 2
      t.timestamps
    end
  end
end

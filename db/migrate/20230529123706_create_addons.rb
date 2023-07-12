class CreateAddons < ActiveRecord::Migration[6.0]
  def change
    create_table :addons do |t|
      t.string :name
      t.float :price
      t.string :description
      t.references :product, null: true, foreign_key: true
      t.boolean :is_public, default: true

      t.timestamps
    end
  end
end

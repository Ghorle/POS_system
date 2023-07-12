class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :customer_name, null: false
      t.string :customer_contact
      t.string :reference_no
      t.float :gross_total
      t.float :tax
      t.float :payable_total
      t.float :discount
      t.references :employee, null: true, foreign_key: { to_table: 'users' }

      t.timestamps
    end
  end
end

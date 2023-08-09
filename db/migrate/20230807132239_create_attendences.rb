class CreateAttendences < ActiveRecord::Migration[6.0]
  def change
    create_table :attendences do |t|
      t.text :remark
      t.string :type
      t.string :status
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

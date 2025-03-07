class RenameRemarkstToRemark < ActiveRecord::Migration[6.0]
  def change
    rename_column :attendences, :remark, :remark
  end
end

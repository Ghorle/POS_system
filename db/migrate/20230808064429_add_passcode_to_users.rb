class AddPasscodeToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :passcode, :string
  end
end

class UserUpdates < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :sex
      t.boolean :is_admin
    end
  end
end

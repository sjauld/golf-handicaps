class TeeNeedsPar < ActiveRecord::Migration
  def change
    change_table :tees do |t|
      t.integer :par
    end
  end
end

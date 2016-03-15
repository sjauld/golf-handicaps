class RoundUpdates < ActiveRecord::Migration
  def change
    change_table :rounds do |t|
      t.integer :adjusted_gross_score
      t.float :differential
      t.float :daily_scratch_rating 
    end
  end
end

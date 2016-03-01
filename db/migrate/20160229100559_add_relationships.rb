class AddRelationships < ActiveRecord::Migration
  def change
    change_table :competitions do |t|
      t.belongs_to :user
    end

    change_table :games do |t|
      t.belongs_to :season
      t.belongs_to :tee
    end

    change_table :rounds do |t|
      t.belongs_to :user
      t.belongs_to :game
      t.belongs_to :tee
    end

    change_table :seasons do |t|
      t.belongs_to :competition
    end

    change_table :tees do |t|
      t.belongs_to :course
    end

    change_table :users do |t|
      t.belongs_to :competition
    end
  end
end

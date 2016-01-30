class InitialSetup < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :image
      t.float :handicap
    end

    create_table :competitions do |t|
      t.string :name
      t.string :image
    end

    create_table :seasons do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.string :image
    end

    create_table :games do |t|
      t.string :name
      t.string :image
      t.integer :dsr
    end

    create_table :rounds do |t|
      t.date :played_date
      t.float :playing_handicap
      t.string :format
      t.integer :score
      t.integer :points
    end

    create_table :courses do |t|
      t.string :name
      t.string :website
      t.string :image
    end

    create_table :tees do |t|
      t.string :colour
      t.integer :acr
      t.integer :slope
    end
  end
end

class BatchFunctionality < ActiveRecord::Migration
  def change
    change_table :rounds do |t|
      t.float       :normal_deduction
      t.float       :weighting_factor
      t.float       :ga_handicap
      t.boolean     :excluded_from_dsr_calculations
      t.belongs_to  :batch
    end

    create_table :batches do |t|
      t.integer     :dsr
      t.float       :wca
      t.float       :cpa
      t.string      :format
      t.string      :sex
      t.date        :date
      t.belongs_to  :tee
    end

  end
end

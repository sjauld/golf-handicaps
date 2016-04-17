class Tee < ActiveRecord::Base
  belongs_to :course
  has_many :games
  has_many :rounds
  has_many :batches
end

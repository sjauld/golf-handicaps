class Game < ActiveRecord::Base
  belongs_to :season
  has_many :rounds
  belongs_to :tee
end

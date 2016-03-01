class Season < ActiveRecord::Base
  belongs_to :competition
  has_many :games
end

class Round < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  belongs_to :tee
end

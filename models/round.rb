class Round < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  belongs_to :tee

  def update_round_statistics
    # stand alone round?
    if self.game.nil?
      update_attribute(:daily_scratch_rating,self.tee.acr)
      update_attribute(:adjusted_gross_score,self.tee.par + self.playing_handicap + 36 + self.gross_stableford_score)
    # otherwise, apply formula and update all rounds
    else
      all_rounds = Game.find(self.game_id)
    end
  end

end

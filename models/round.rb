class Round < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  belongs_to :tee

  def update_round_statistics
    # stand alone round?
    if self.game.nil?
      update_attribute(:daily_scratch_rating,self.tee.acr)
      update_attribute(:adjusted_gross_score,self.tee.par + self.playing_handicap + 36 - self.score)
      unrounded_differential = (self.adjusted_gross_score + (self.fomat == "P" ? 36 : 0) - self.daily_scratch_rating) * 113 / self.tee.slope
      cap = ( self.user.sex == 'F' ? 50 : 40 )
      diff = [((((unrounded_differential) * 10) + 0.5).floor)/10,cap].min
      update_attribute(:differential,diff)
      # update the handicap of the player
      self.user.update_handicap
    # otherwise, apply formula and update all rounds
    else
      # TODO: build
      all_rounds = Game.find(self.game_id)
    end
  end

end

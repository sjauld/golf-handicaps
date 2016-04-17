class Round < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  belongs_to :tee
  belongs_to :batch

  before_save :update_round_statistics
  after_save :update_user_handicap

  # DSR constants
  @@dsr_constants = {
    men: {
      p: {m: 0.052, b: 2.777, mm: 0.025, bb: 2.824},
      s: {m: 0.111, b: 3.498, mm: 0.060, bb: 3.545},
      k: {m: 0.124, b: 4.372, mm: 0.086, bb: 3.715}
    },
    women: {
      p: {m: 0.062, b: 2.514, mm: 0.030, bb: 2.653},
      s: {m: 0.117, b: 3.338, mm: 0.060, bb: 3.478},
      k: {m: 0.146, b: 3.939, mm: 0.084, bb: 3.609}
    }
  }

  #########
  protected
  #########

  def update_round_statistics
    self.daily_scratch_rating = self.batch.dsr || self.tee.acr
    self.adjusted_gross_score = self.tee.par + self.playing_handicap + 36 - self.score
    unrounded_differential = (self.adjusted_gross_score + (self.format == "P" ? 36 : 0) - self.daily_scratch_rating) * 113 / self.tee.slope
    cap = ( self.user.sex == 'F' ? 50 : 40 )
    diff = [((((unrounded_differential) * 10) + 0.5).floor)/10,cap].min
    self.differential = diff
    # DSR functionality
    if self.ga_handicap.nil? || self.ga_handicap > 42.4 || ( self.ga_handicap > 33.4 && self.user.sex.upcase == 'M')
      self.excluded_from_dsr_calculations = true
    else
      my_constants = @@dsr_constants[self.user.sex == 'F' ? :women : :men][self.format.downcase.to_sym]
      self.excluded_from_dsr_calculations = false
      self.normal_deduction = my_constants[:m] * self.ga_handicap + my_constants[:b]
      self.weighting_factor = 1 / (my_constants[:mm] * self.ga_handicap + my_constants[:bb])
    end
  end

  def update_user_handicap
    self.user.update_handicap
  end

end

class Batch < ActiveRecord::Base
  has_many :rounds
  belongs_to :tee

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

  @@csd = 1.5 # this is always the course standard deviation according to Golf Australia

  def calculate_dsr
    rounds = self.rounds.where(excluded_from_dsr_calculations: false || nil)
    my_tee = self.tee
    # Grab the relevant constants hash (TODO: move to rounds)
    my_constants = @@dsr_constants[self.sex == 'F' ? :women : :men][self.format.downcase.to_sym]
    # TODO: cpa - store against the batch
    previous_batch = Batch.where('date < ? AND sex = ? AND tee_id = ? AND format = ?', self.date, self.sex, self.tee_id, self.format).order(date: :desc).limit(1).first
    # Course Parameter Adjustment
    self.cpa = previous_batch.nil? ? 0 : previous_batch.cpa + previous_batch.wca * 0.02 * self.sex == 'F' ? 0.5 : 0.7 rescue 0
    # Weighted Condition Adjustment
    self.wca = rounds.map{|x| (36 + my_tee.par - my_tee.acr - cpa - x.normal_deduction - x.score + (x.format == "P" ? 36 : 0)) / (x.weighting_factor)}.reduce(:+).to_f / (rounds.map{|x| x.weighting_factor}.reduce(:+).to_f + 1 / @@csd ** 2)
    self.dsr = my_tee.acr + self.wca
    self.save
  end


end

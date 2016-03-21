class User < ActiveRecord::Base
  has_many :rounds
  has_and_belongs_to_many :competitions
  has_secure_password validations: false

  def update_handicap
    rounds = self.rounds.order(played_date: :desc).limit(20)
    # work out how many rounds will be used for handicapping purposes
    n = [8,[1,(rounds.count/2.0-2).ceil].max].min
    # select the best rounds
    counted_rounds = rounds.reorder(differential: :asc).limit(n)
    # maybe there is a better way instead of map reduce but I couldn't work it out
    update_attribute(:handicap,(((counted_rounds.map{|x| x.differential}.reduce(:+) / n) * 0.93 * 10).floor / 10.0))
  end

end

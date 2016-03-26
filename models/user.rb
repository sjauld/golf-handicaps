class User < ActiveRecord::Base
  has_many :rounds
  has_and_belongs_to_many :competitions
  has_secure_password validations: false

  # TODO: add sex of user and apply different rules for women
  def update_handicap
    rounds = self.rounds.order(played_date: :desc).limit(20)
    # work out how many rounds will be used for handicapping purposes
    n = [8,[1,(rounds.count/2.0-2).ceil].max].min
    # select the best rounds
    counted_rounds = rounds.reorder(differential: :asc).limit(n)
    # maybe there is a better way instead of map reduce but I couldn't work it out
    update_attribute(:handicap,[(((counted_rounds.map{|x| [x.differential,40].min}.reduce(:+) / n) * 0.93 * 10).floor / 10.0),36.4].min)
  end

  def admin?
    # TODO: update the database to include an admin flag
    self.email == ENV['ADMIN_EMAIL_ADDRESS']
  end

end

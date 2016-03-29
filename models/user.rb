class User < ActiveRecord::Base
  has_many :rounds
  has_and_belongs_to_many :competitions
  has_secure_password validations: false

  def update_handicap
    # TODO: this can be removed once the database is cleaned
    diff_cap = self.sex == 'F' ? 50 : 40
    # set the max handicap based on sex
    hcp_cap = self.sex == 'F' ? 45.4 : 36.4
    rounds = self.rounds.order(played_date: :desc).limit(20)
    # work out how many rounds will be used for handicapping purposes
    n = [8,[1,(rounds.count/2.0-2).ceil].max].min
    # select the best rounds
    counted_rounds = rounds.reorder(differential: :asc).limit(n)
    # maybe there is a better way instead of map reduce but I couldn't work it out
    update_attribute(:handicap,[(((counted_rounds.map{|x| [x.differential,diff_cap].min}.reduce(:+) / n) * 0.93 * 10).floor / 10.0),hcp_cap].min)
  end

  def admin?
    self.email == ENV['ADMIN_EMAIL_ADDRESS'] || self.is_admin
  end

end

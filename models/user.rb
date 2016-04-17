class User < ActiveRecord::Base
  include Gravtastic

  has_many :rounds
  has_and_belongs_to_many :competitions
  has_secure_password validations: false
  is_gravtastic

  @@max_handicap_male   = 36.4
  @@max_handicap_female = 45.4
  @@max_diff_male       = 40
  @@max_diff_female     = 50
  @@ga_multiplier       = 0.93

  def update_handicap
    update_attribute(:handicap,calculate_handicap(recent_rounds))
  end

  def admin?
    self.email == ENV['ADMIN_EMAIL_ADDRESS'] || self.is_admin
  end

  def diff_cap
    self.sex == 'F' ? @@max_diff_female : @@max_diff_male
  end

  def hcp_cap
    self.sex == 'F' ? @@max_handicap_female : @@max_handicap_male
  end

  def recent_rounds(n=20)
    self.rounds.order(played_date: :desc).limit(n)
  end

  def calculate_handicap(rounds)
    # Are there enough rounds?
    if rounds.count > 2
      n = [8,[1,(rounds.count/2.0-2).ceil].max].min
      best_n_rounds = rounds.reorder(differential: :asc).limit(n)
      [(((best_n_rounds.map{|x| [x.differential,diff_cap].min}.reduce(:+) / n) * @@ga_multiplier * 10).floor / 10.0),hcp_cap].min
    else
      nil
    end
  end

end

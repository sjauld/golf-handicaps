require_relative 'user'

class User < ActiveRecord::Base
  has_many :rounds
  has_and_belongs_to_many :competitions

end

class Competition < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :seasons

end

class Season < ActiveRecord::Base
  belongs_to :competition
  has_many :games
end

class Game < ActiveRecord::Base
  belongs_to :season
  has_many :rounds
  belongs_to :tee
end

class Round < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  belongs_to :tee
end

class Course < ActiveRecord::Base
  has_many :tees

end

class Tee < ActiveRecord::Base
  belongs_to :course
  has_many :games
  has_many :rounds
end

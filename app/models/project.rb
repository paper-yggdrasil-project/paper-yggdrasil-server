class Project < ActiveRecord::Base
  validates :name, uniqueness: true
  validates :name, presence: true

end

class Project < ActiveRecord::Base
  validates :name, uniqueness: true
  validates :name, presence: true
  validates :user_id, presence: true

  belongs_to :user

end

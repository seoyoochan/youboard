class Subscription < ActiveRecord::Base
  resourcify
  belongs_to :user
  has_many :boards


end

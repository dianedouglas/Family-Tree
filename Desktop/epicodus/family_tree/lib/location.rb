class Location < ActiveRecord::Base
  has_and_belongs_to_many :people
end

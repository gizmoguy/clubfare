class Brewer < ActiveRecord::Base
	has_many :beers

	validates :name, length: { maximum: 100 }
	validates :location, length: { maximum: 100 }
	validates :account, length: { minimum: 2 }
end

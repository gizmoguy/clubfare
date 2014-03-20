class Location < ActiveRecord::Base
	has_many :beers

	validates: :name, length: { maximum: 100 }, presence: true
	validates: :location, length: { maximum: 100 }, presence: true
end

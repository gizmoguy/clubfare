class Format < ActiveRecord::Base
	has_many :beers

	validates :name, length: { maximum: 100 }, presence: true
	validates :size, presence: true
end

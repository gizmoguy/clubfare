class Style < ActiveRecord::Base
	has_many :beers

	validates: :name, length: { maximum: 100 }, presence: true
end

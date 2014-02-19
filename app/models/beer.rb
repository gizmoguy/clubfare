class Beer < ActiveRecord::Base
	belongs_to :brewer
	belongs_to :style
	belongs_to :location
	belongs_to :format
	
	validates :name, length: { maximum: 254 }

	Wastage = 0.05

	def self.markup(method)
		if method == "tap"
			return 2.811
		else
			return 2
		end
	end

	def pricefor(serving, method)
		volume = self.format.size
		(self.price) / (volume - (volume * Wastage)) / 1000 * serving * self.class.markup(method)
	end

	def self.ontap
		@beers = self.joins(:location,:brewer).where(locations: { status: ['LOW','SERVING'] }).select("beers.id, brewers.name AS brewer_name, beers.name, beers.price, locations.name AS currently, 2.811 AS tapmarkup, 2 AS offmarkup")
	end

end

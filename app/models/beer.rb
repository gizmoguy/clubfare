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
		self.joins(:location).where(locations: { status: ['LOW','SERVING'] }).includes(:brewer)
	end

end

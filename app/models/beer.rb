class Beer < ActiveRecord::Base
	belongs_to :brewer
	belongs_to :style
	belongs_to :location
	belongs_to :format
	
	validates :name, length: { maximum: 254 }

	Wastage = 0.05

	TapMarkup = 2.811
	OffLicenseMarkup = 2

	Markups = { tap: 2.811, off: 2 }.tap { |m| m.default = m[:off] }

	def pricefor(serving_size, method)
		available_beer = self.format.size - (self.format.size * Wastage)
		price = ( (self.price * Markups[method] ) / ( available_beer / serving_size) ).round(1)
	end

	class <<self
		
		def ontap
			self.joins(:location).where(locations: { status: ['LOW','SERVING'] }).includes(:brewer)
		end

	end

end

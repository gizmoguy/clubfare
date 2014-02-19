class Beer < ActiveRecord::Base
	belongs_to :brewer
	belongs_to :style
	belongs_to :location
	belongs_to :format
	
	validates :name, length: { maximum: 254 }

	Wastage = 0.05

	TapMarkup = 2.811
	OffLicenseMarkup = 2

	class <<self
		def markup(method)
			if method == "tap"
				return TapMarkup
			else
				return OffLicenseMarkup
			end
		end

		def ontap
			self.joins(:location).where(locations: { status: ['LOW','SERVING'] }).includes(:brewer)
		end
	
		def pricefor(serving, method)
			volume = self.format.size
			(self.price) / (volume - (volume * Wastage)) / 1000 * serving * self.class.markup(method)
		end
	end

end

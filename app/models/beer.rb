class Beer < ActiveRecord::Base
	belongs_to :brewer
	belongs_to :style
	belongs_to :location
	belongs_to :format
	
	validates :name, length: { maximum: 254 }

	after_save :update_file

	Wastage = 0.00

	Tax = 1.15

	Markups = { tap: 0.40, off: 0.47 }.tap { |m| m.default = m[:off] }

	def pricefor(serving_size, method)
		available_beer = self.format.size - (self.format.size * Wastage)
		freight_per_litre = self.freight / available_beer
		net_cost_per_litre = self.price / available_beer
		# price = ( (self.price * Markups[method] ) / ( available_beer / serving_size) * Tax ).round(1)
		price = ( ( net_cost_per_litre / Markups[method] + freight_per_litre ) * serving_size * Tax ).round(1)
	end

	class <<self
		
		def ontap
			self.joins(:location).where(locations: { status: ['LOW','SERVING'] }).includes(:brewer)
		end

		def search(search, page)
			paginate :per_page => 15, :page => page,
				:conditions => ['name LIKE ?', "%#{search}%"],
				:order => 'location_id'
		end

	end

	def update_file
		path = File.join(Rails.root, 'app', 'tmp', 'clubfare', 'beer_updated')
		data = "Record Updated"
		File.open(path, 'w') do |f|
			f.write(data)
		end
	end

end

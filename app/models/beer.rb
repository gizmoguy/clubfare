class Beer < ActiveRecord::Base
	belongs_to :brewer
	belongs_to :style
	belongs_to :location
	belongs_to :format
	
	validates :name, length: { maximum: 254 }

	after_save :update_file

#	Wastage = 0.00

#	Tax = 1.15

#	Markups = { tap: 0.40, off: 0.47 }.tap { |m| m.default = m[:off] }

#	def pricefor(serving_size, method)
#		available_beer = self.format.size - (self.format.size * Wastage)
#		freight_per_litre = self.freight / available_beer
#		net_cost_per_litre = self.price / available_beer
#		# price = ( (self.price * Markups[method] ) / ( available_beer / serving_size) * Tax ).round(1)
#		price = ( ( net_cost_per_litre / Markups[method] + freight_per_litre ) * serving_size * Tax ).round(1)
#	end

# Lookup tables for pricing. Better to calc per ml, but abandoned by manager for simplicity.
# We assume that the lowest cost is a small vessel, hence the much higher markup on lower cost.

	Price_lookup_handle = {
		100..150 => 8.70,
		200..270 => 7.00,
		271..290 => 7.50,
		291..310 => 7.80,
		311..330 => 8.00,
		331..350 => 8.70,
		351..490 => 9.70
	}

	Price_lookup_benny = {
		100..150 => 8.00,
		200..270 => 6.50,
		271..290 => 7.00,
		291..310 => 7.20,
		311..330 => 7.40,
		331..350 => 8.00,
		351..490 => 9.00
	}

	Price_lookup_glass = {
		100..150 => 5.20,
		200..270 => 4.20,
		271..290 => 4.50,
		291..310 => 4.60,
		311..330 => 4.80,
		331..350 => 5.20,
		351..490 => 5.80
	}

	Price_lookup_half = {
		100..150 => 5.00,
		200..270 => 4.00,
		271..290 => 4.20,
		291..310 => 4.40,
		311..330 => 4.50,
		331..350 => 5.00,
		351..490 => 5.50
	}

	Price_lookup_rigger_large = {
		100..150 => 28.00,
		200..270 => 22.50,
		271..290 => 24.00,
		291..310 => 25.00,
		311..330 => 26.60,
		331..350 => 28.00,
		351..490 => 35.00
	}

	Price_lookup_rigger_small = {
		100..150 => 17.50,
		200..270 => 12.00,
		271..290 => 15.00,
		291..310 => 15.60,
		311..330 => 16.60,
		331..350 => 17.50,
		351..490 => 22.00
	}

	def pricefor(serving_size, method)
		# defined here so it's in scope for after the each
		price = 0

		price_table_for(method).each do |range, serve_price| 
			if range.include?self.price
				price = serve_price
      			break
    		end
		end

		# Warning, if there's no match in the price table
		# it'll calculate a cost of $0, add a validation
		# somewhere so you don't give away free beer
		price
	end

	def price_table_for(method)  
		case method
		when :half
			Price_lookup_half
		when :handle
			Price_lookup_handle
		when :benny
			Price_lookup_benny
		when :glass
			Price_lookup_glass
		when :rigger_small
			Price_lookup_rigger_small
		else
			Price_lookup_rigger_large
		end
	end

	class <<self
		
		def ontap
			self.joins(:location).where(locations: { status: ['LOW','SERVING'] }).includes(:brewer, :format)
		end

		def search(search, page)
			order('location_id').where('name LIKE ?', "%#{search}%").paginate(page: page, per_page: 10)
		end

		def menu
			self.joins(:location).where(locations: { status: ['INBOUND','STOCK','SERVING','NEXT'] }).includes(:brewer)
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

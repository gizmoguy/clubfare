class Beer < ActiveRecord::Base
	belongs_to :brewer
	belongs_to :style
	belongs_to :location
	belongs_to :format
	
	validates :name, length: { maximum: 100 }, presence: true, uniqueness: true
	validates :brewer_id, presence: true
	validates :format_id, presence: true
	validates :style_id, presence: true
	validates :location_id, presence: true
	validates :price, presence: true, numericality: true
	validates :abv, presence: true, numericality: true
	validates :freight, presence: true, numericality: true

	after_save :update_file

# Lookup tables for pricing. Better to calc per ml, but abandoned by manager for simplicity.
# We assume that the lowest cost is a small vessel, hence the much higher markup on lower cost.

	Price_lookup_handle = {
		0.00..254.99 => 7.00,
		255.00..259.99 => 7.20,
		260.00..264.99 => 7.30,
		265.00..269.99 => 7.40,
		270.00..274.99 => 7.60,
		275.00..279.99 => 7.70,
		280.00..284.99 => 7.90,
		285.00..289.99 => 8.00,
		290.00..294.99 => 8.10,
		295.00..299.99 => 8.30,
		300.00..304.99 => 8.40,
		305.00..309.99 => 8.60,
		310.00..314.99 => 8.70,
		315.00..319.99 => 8.80,
		320.00..324.99 => 9.00,
		325.00..329.99 => 9.10,
		330.00..349.99 => 9.30,
		350.00..484.99 => 9.80,
		485.00..600.99 => 10.20
	}

	Price_lookup_benny = {
		0.00..254.99 => 6.50,
		255.00..259.99 => 6.70,
		260.00..264.99 => 6.80,
		265.00..269.99 => 6.90,
		270.00..274.99 => 7.00,
		275.00..279.99 => 7.20,
		280.00..284.99 => 7.30,
		285.00..289.99 => 7.40,
		290.00..294.99 => 7.60,
		295.00..299.99 => 7.70,
		300.00..304.99 => 7.80,
		305.00..309.99 => 8.00,
		310.00..314.99 => 8.10,
		315.00..319.99 => 8.20,
		320.00..324.99 => 8.30,
		325.00..329.99 => 8.50,
		330.00..349.99 => 8.60,
		350.00..484.99 => 9.10,
		485.00..600.99 => 9.50
	}

	Price_lookup_glass = {
		0.00..254.99 => 4.20,
		255.00..259.99 => 4.30,
		260.00..264.99 => 4.40,
		265.00..269.99 => 4.50,
		270.00..274.99 => 4.50,
		275.00..279.99 => 4.60,
		280.00..284.99 => 4.70,
		285.00..289.99 => 4.80,
		290.00..294.99 => 4.90,
		295.00..299.99 => 5.00,
		300.00..304.99 => 5.00,
		305.00..309.99 => 5.10,
		310.00..314.99 => 5.20,
		315.00..319.99 => 5.30,
		320.00..324.99 => 5.40,
		325.00..329.99 => 5.50,
		330.00..349.99 => 5.60,
		350.00..484.99 => 5.90,
		485.00..600.99 => 6.10
	}

	Price_lookup_half = {
		0.00..254.99 => 4.00,
		255.00..259.99 => 4.10,
		260.00..264.99 => 4.20,
		265.00..269.99 => 4.20,
		270.00..274.99 => 4.30,
		275.00..279.99 => 4.40,
		280.00..284.99 => 4.50,
		285.00..289.99 => 4.60,
		290.00..294.99 => 4.60,
		295.00..299.99 => 4.70,
		300.00..304.99 => 4.80,
		305.00..309.99 => 4.90,
		310.00..314.99 => 5.00,
		315.00..319.99 => 5.00,
		320.00..324.99 => 5.10,
		325.00..329.99 => 5.20,
		330.00..349.99 => 5.30,
		350.00..484.99 => 5.60,
		485.00..600.99 => 5.80
	}

	Price_lookup_rigger_large = {
		0.00..254.99 => 16.40,
		255.00..259.99 => 16.80,
		260.00..264.99 => 17.10,
		265.00..269.99 => 17.40,
		270.00..274.99 => 17.70,
		275.00..279.99 => 18.10,
		280.00..284.99 => 18.40,
		285.00..289.99 => 18.70,
		290.00..294.99 => 19.10,
		295.00..299.99 => 19.40,
		300.00..304.99 => 19.70,
		305.00..309.99 => 20.00,
		310.00..314.99 => 20.40,
		315.00..319.99 => 20.70,
		320.00..324.99 => 21.00,
		325.00..329.99 => 21.40,
		330.00..349.99 => 21.70,
		350.00..484.99 => 23.00,
		485.00..600.99 => 31.90
	}

	Price_lookup_rigger_small = {
		0.00..254.99 => 10.30,
		255.00..259.99 => 10.50,
		260.00..264.99 => 10.70,
		265.00..269.99 => 10.90,
		270.00..274.99 => 11.10,
		275.00..279.99 => 11.30,
		280.00..284.99 => 11.50,
		285.00..289.99 => 11.70,
		290.00..294.99 => 11.90,
		295.00..299.99 => 12.10,
		300.00..304.99 => 12.30,
		305.00..309.99 => 12.50,
		310.00..314.99 => 12.70,
		315.00..319.99 => 12.90,
		320.00..324.99 => 13.10,
		325.00..329.99 => 13.30,
		330.00..349.99 => 13.60,
		350.00..484.99 => 14.40,
		485.00..600.99 => 19.90
	}

	def pricefor(serving_size, method)
		# defined here so it's in scope for after the each
		price = 0
		price_per_fiftylitre = ( self.price / self.format.size ) * 50
		price_table_for(method).each do |range, serve_price| 
			if range.include?price_per_fiftylitre
				price = serve_price
      			break
    		end
		end

		# Warning, if there's no match in the price table
		# it'll calculate a cost of $0, a validation is added
		# in the beers_helper so we don't give away free beer
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

		def empties
			self.joins(:location).where(locations: { status: ['EMPTY','RETURNING'] }).includes(:brewer)
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

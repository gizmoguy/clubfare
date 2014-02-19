module BeersHelper

	def beer_price(beer, serving_size)
		price = ( (beer.price * Beer.markup("tap")) / (beer.format.size / serving_size) ).round(1)
		number_to_currency(price, precision: 2)
	end

end

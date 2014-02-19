module BeersHelper

	def beer_price(beer, serving_size, method)
		price = ( (beer.price * Beer.markup(:method)) / (beer.format.size / serving_size) ).round(1)
		number_to_currency(price, precision: 2)
	end

end

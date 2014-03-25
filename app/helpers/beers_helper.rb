module BeersHelper

	def beer_price(beer, serving_size, method)
#		waste = beer.format.size * Beer::Wastage
#		price = ( (beer.price * Beer::Markups[method] ) / ( (beer.format.size - waste) / serving_size) ).round(1)
		price = number_to_currency(beer.pricefor(serving_size, method), precision: 2)
		if price == "$0.00"
			"N/A"
		else
			price
		end
	end

end

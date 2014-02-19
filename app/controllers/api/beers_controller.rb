class Api::BeersController < ApiController

	def index
		@beers = Beer.ontap
		render json: @beers
	end

end

class Api::BeersController < ApiController
	after_filter :cors_set_access_control_headers

	def cors_set_access_control_headers
		headers['Access-Control-Allow-Origin'] = '*'
		headers['Access-Control-Allow-Methods'] = 'GET'
		headers['Access-Control-Allow-Headers'] = '*'
	end

	def index
		@beers = Beer.ontap
		render json: @beers
	end

end

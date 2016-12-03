class Api::BeersController < ApiController
	after_filter :cors_set_access_control_headers

	def cors_set_access_control_headers
		headers['Access-Control-Allow-Origin'] = '*'
		headers['Access-Control-Allow-Methods'] = 'GET'
		headers['Access-Control-Allow-Headers'] = '*'
	end

	def index
		@beers = Beer.joins(:location).joins(:brewer).joins(:style).where(locations: { status: ['NEXT','LOW','SERVING'] }).order(:location_id)
		render json: @beers, :include => {
			:brewer => {:only => [:id, :name, :location]},
			:location => {:only => [:id, :name, :status]},
			:style => {:only => [:id, :name]}
		}, :except => [:brewer_id, :location_id, :style_id, :format_id, :price, :freight]
	end

end

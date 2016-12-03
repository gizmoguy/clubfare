class DashController < ApplicationController
	skip_before_filter :authenticate_user!

	def index
        response.headers.delete "X-Frame-Options"
		@beers = Beer.joins(:location).where(locations: { status: ['NEXT','LOW','SERVING'] }).order(:location_id)
		respond_to do |format|
			format.html { }
			format.js { }
		end
	end
end

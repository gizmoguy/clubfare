class DashController < ApplicationController
	skip_before_filter :authenticate_user!
	after_filter :sameorigin_unset_control_headers

	def sameorigin_unset_control_headers
		headers.delete "X-Frame-Options"
	end

	def index
		@beers = Beer.joins(:location).where(locations: { status: ['NEXT','LOW','SERVING'] }).order(:location_id)
		respond_to do |format|
			format.html { }
			format.js { }
		end
	end
end

class DashController < ApplicationController
	skip_before_filter :authenticate_user!

    def my_embeddable_widget
        response.headers.delete "X-Frame-Options"
        render
    end

	def index
		@beers = Beer.joins(:location).where(locations: { status: ['NEXT','LOW','SERVING'] }).order(:location_id)
		respond_to do |format|
			format.html { }
			format.js { }
		end
	end
end

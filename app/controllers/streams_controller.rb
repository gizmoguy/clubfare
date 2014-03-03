require 'reloader/sse'

class StreamsController < ApplicationController
	include ActionController::Live

	def dash
		@beers = Beer.joins(:location).where(locations: { status: ['NEXT','LOW','SERVING'] }).order(:location_id)
		respond_to do |format|
			format.html { }
			format.js { }
		end
	end

	def update_stream
		response.headers['Content-Type'] = 'text/event-stream'
		sse = Reloader::SSE.new(response.stream)

		begin
			updated = File.join(Rails.root, 'app', 'tmp', 'clubfare')
			notifier = INotify::Notifier.new
			
			notifier.watch(updated, :close_write) do |file|
				sse.write({ :time => Time.now }, :event => 'refresh')
			end
			notifier.run

		rescue IOError
			logger.info "Stream closed"
		ensure
			sse.close
		end
	end

end

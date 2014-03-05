class BrewersController < ApplicationController
	before_filter :get_brewer, only: [:show, :edit, :update, :destroy]

	def index
		@brewers = Brewer.search(params[:search],params[:page])
	end

	def show
	end

	def new
		@brewer = Brewer.new
	end

	def create
		@brewer = Brewer.new(brewer_params)
		respond_to do |format|
			if @brewer.save
				format.html { redirect_to brewers_path, notice: 'Brewer was successfully created.' }
				format.json { render action: 'show', status: :created, location: @brewer }
			else
				format.html { render action: 'new' }
				format.json { render json: @brewer.errors, status: :unprocessable_entity }
			end
		end
	end

	def edit
	end

	def update
		respond_to do |format|
			if @brewer.update(brewer_params)
				format.html { redirect_to brewers_path, notice: 'Brewer was successfully updated.' }
				format.json { render action: 'show', status: :created, location: @brewer }
			else
				format.html { render action: 'show' }
				format.json { render json: @brewer.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@brewer.destroy
 		respond_to do |format|
			format.html { render :html }
			format.json { head :no_content }
		end
	end

private
	
	def get_brewer
		@brewer = Brewer.find(params[:id])
	end

	def brewer_params
		params.require(:brewer).permit(:name, :location, :account)
	end

end

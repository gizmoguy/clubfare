class BeersController < ApplicationController
	before_filter :get_beer, only: [:show, :edit, :update, :destroy, :label]

	def index
		@beers = Beer.search(params[:search],params[:page])
	end

	def show
	end

	def new
		@beer = Beer.new
	end

	def create
		@beer = Beer.new(beer_params)
		respond_to do |format|
			if @beer.save
				format.html { redirect_to beers_path, notice: 'Beer was successfully created.' }
				format.json { render action: 'show', status: :created, location: @beer }
			else
				format.html { render action: 'new' }
				format.json { render json: @beer.errors, status: :unprocessable_entity }
			end
		end
	end

	def edit
	end

	def update
		respond_to do |format|
			if @beer.update(beer_params)
				format.html { redirect_to beers_path, notice: 'Beer was successfully updated.' }
				format.json { render action: 'show', status: :created, location: @beer }
			else
				format.html { render action: 'show' }
				format.json { render json: @beer.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@beer.destroy
 		respond_to do |format|
			format.html { render :html }
			format.json { head :no_content }
		end
	end

	def label
		Ruakura::Tapbadge.font_file = 'vendor/assets/fonts/familiar_pro.ttf'
		full = @beer.pricefor(0.5, :tap)
		half = @beer.pricefor(0.25, :tap)
		name = @beer.brewer.name + ' ' + @beer.name
		send_data Ruakura::Tapbadge.badge_for(name: name, style: @beer.style.name, abv: @beer.abv, full: full, half: half), :filename => 'TapBadge.pdf', :type => 'application/pdf', :disposition => 'inline'
	end

private
	
	def get_beer
		@beer = Beer.find(params[:id])
	end

	def beer_params
		params.require(:beer).permit(:name, :brewer_id, :format_id, :price, :freight, :style_id, :abv, :note, :location_id)
	end

end

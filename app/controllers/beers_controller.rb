class BeersController < ApplicationController
	before_filter :get_beer, only: [:show, :edit, :update, :destroy, :label]

	def index
		@beers = Beer.search(params[:search],params[:page])
		fresh_when @beers
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
				format.html { redirect_to @beer, alert: 'Parameters missing or incorrect. Beer not updated.' }
#							  redirect_to @beer
#							}
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
		full = @beer.pricefor(500, :handle)
		half = @beer.pricefor(285, :half)
		name = @beer.brewer.name + ' ' + @beer.name
		send_data Ruakura::Tapbadge.badge_for(name: name, style: @beer.style.name, abv: @beer.abv, full: full, half: half), :filename => 'TapBadge.pdf', :type => 'application/pdf', :disposition => 'inline'
	end

	def menu
		@beers = Beer.menu
	end

	def menushort
		@beers = Beer.ontap
	end

	def empties
		@beers = Beer.empties
	end

private
	
	def get_beer
		@beer = Beer.find(params[:id])
	end

	def beer_params
		params.fetch(:beer, {}).permit(:name, :brewer_id, :format_id, :price, :freight, :style_id, :abv, :note, :location_id, :handpull)
	end

end

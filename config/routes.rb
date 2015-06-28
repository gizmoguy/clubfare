Clubfare::Application.routes.draw do

  devise_for :users

	resources :beers
	resources :brewers
	resources :users
	resources :dash

	namespace :api do
		resources :beers
	end

	root 'dash#index'

	match '/dash',		to: 'dash#index',			via: 'get'

	# Beer label generation
	match 'beers/:id/label' => 'beers#label', as: :beers_label, via: 'get'

	# Beer tasting notes
	match '/menu',			to: 'beers#menu',				via: 'get'
	match '/menushort',		to: 'beers#menushort',			via: 'get'
	
	# Empty kegs for return
	match '/empties',		to: 'beers#empties',	via: 'get'
	
end

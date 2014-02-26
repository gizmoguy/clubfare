Clubfare::Application.routes.draw do
  resources :beers

	resources :beers
	resources :sessions, only: [:new, :create, :destroy]

	namespace :api do
		resources :beers
	end

	root 'beers#dash'

	match '/dash',		to: 'beers#dash',			via: 'get'
	match '/signin',	to: 'sessions#new',			via: 'get'
	match '/signout',	to: 'sessions#destroy',		via: 'delete'

	# Allow SSE streaming
	get 'streaming' => 'beers#update_stream', as: 'streaming'

end

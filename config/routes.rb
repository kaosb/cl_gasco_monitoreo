Rails.application.routes.draw do

	devise_for :users

	root to: "services#dashboard"
	
	scope '/services' do
		get '/:service_id' => 'services#show'
		get '/action/:action_id' => 'services#show_action'
	end

	scope '/alert' do
		get '/index' => 'alert#index'
	end

	get 'test/msj' => 'services#testmsj'
	get 'test/action/:id' => 'services#testaction'
	get 'test/all' => 'services#testall'

end

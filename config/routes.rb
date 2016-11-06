Rails.application.routes.draw do

	devise_for :users

	root to: "services#dashboard"
	
	scope '/services' do
		get '/:service_id' => 'services#show'
		get '/action/:action_id' => 'services#show_action'
	end

end

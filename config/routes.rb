Rails.application.routes.draw do

	devise_for :users

	root to: "services#dashboard"
	
	scope '/services' do
		get '/show/:service_id' => 'services#show'
	end

end

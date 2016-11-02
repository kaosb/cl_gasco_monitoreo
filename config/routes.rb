Rails.application.routes.draw do

  devise_for :users
	# root to: "reports#dashboard"
	root to: "reports#index"
	get 'reports/dashboard'

	scope '/services' do
		get '/show/:service_id' => 'services#show'
	end

	# get 'reports/rfcweb'
	# get 'reports/index'
	# get 'services/wsrfcweb_consultaservicio'
	# get 'services/wsrfcweb_consultaservicio_http'
	# get 'services/wsrfcweb_test'

end

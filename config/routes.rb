Rails.application.routes.draw do

  devise_for :users
	# root to: "reports#dashboard"
	root to: "reports#index"
	get 'reports/dashboard'
	get 'reports/rfcweb'
	get 'reports/index'

	get 'services/wsrfcweb_consultaservicio'
	get 'services/wsrfcweb_consultaservicio_http'

end

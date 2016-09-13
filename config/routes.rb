Rails.application.routes.draw do

	root to: "reports#dashboard"
	get 'reports/dashboard'
	get 'reports/index'

end

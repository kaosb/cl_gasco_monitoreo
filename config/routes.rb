Rails.application.routes.draw do

  devise_for :users
	# root to: "reports#dashboard"
	root to: "reports#index"
	get 'reports/dashboard'
	get 'reports/index'

end

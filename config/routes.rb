Rails.application.routes.draw do

  devise_for :users
	root to: "reports#dashboard"
	get 'reports/dashboard'
	get 'reports/index'

end

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

	scope '/receiver' do
		get '/edit/:id' => 'alert#edit'
	end

	get 'test/msj' => 'services#testmsj'
	get 'test/service/:id' => 'services#testservice'
	get 'test/all' => 'services#testall'

	# AJAX
	post 'add_alert_receiver' => 'alert#add_alert_receiver'
	post 'update_alert_receiver' => 'alert#update_alert_receiver'
	post 'delete_alert_receiver' => 'alert#delete_alert_receiver'
	get  'get_recent_activity' => 'services#recent_activity'
	get  'test_send_gmail' => 'services#test_send_gmail'

end

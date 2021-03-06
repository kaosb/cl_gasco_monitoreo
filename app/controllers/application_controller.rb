class ApplicationController < ActionController::Base
	
	protect_from_forgery with: :null_session, only: Proc.new { |c| c.request.format.json? }
	# protect_from_forgery with: :exception
	before_action :authenticate_user!, :except => [:recent_activity]

	layout :layout_by_resource

	protected

	def layout_by_resource
		if devise_controller? #&& resource_name == :user && action_name == "new"
			"login"
		else
			"application"
		end
	end

end

class ServicesController < ApplicationController

	def show
		@service = Service.find(params[:service_id])
	end

	def dashboard
		
		@logs = Log.where()
	end

end

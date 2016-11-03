class ServicesController < ApplicationController

	def show
		@service = Service.find(params[:service_id])
	end

	def dashboard
		date = DateTime.now
		@logs = Log.where(created_at: date.beginning_of_day..date.end_of_day)
	end

end

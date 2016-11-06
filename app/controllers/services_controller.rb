class ServicesController < ApplicationController

	def show
		@service = Service.find(params[:service_id])
	end

	def show_action
		date = DateTime.now
		@action = Action.find(params[:action_id])
		@log = Log.where(action_id: params[:action_id], created_at: date.beginning_of_day..date.end_of_day)
	end

	def dashboard
		date = DateTime.now
		@logs = Log.where(created_at: date.beginning_of_day..date.end_of_day)
	end

end

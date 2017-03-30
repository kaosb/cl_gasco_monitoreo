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

	def testmsj
		action = Action.find(5)
		response = Service.notify(action)
		render :json => { :status => true, :response => response }, :status => 200
	end

	def testservice
		response = Service.check(params[:id])
		render :json => { :status => true, :response => response }, :status => 200
	end

	def testall
		response = Service.check_all()
		render :json => { :status => true, :response => response }, :status => 200
	end	

end

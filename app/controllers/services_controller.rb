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
		@services = Service.where(status: true)
		@actions = Action.where(status: true)
		@logs_count = Log.all
		@alertreceivers = AlertReceiver.where(status: true)
		date = DateTime.now
		# @logs = Log.where(created_at: date.beginning_of_day..date.end_of_day)
		if params[:stretch] == '24h'
			@logs = Log.where('created_at > ?', 24.hours.ago)
		elsif params[:stretch] == 'week'
			@logs = Log.where('created_at > ?', 7.days.ago)
		elsif params[:stretch] == 'month'
			@logs = Log.where('created_at > ?', 1.month.ago)
		elsif params[:stretch] == '3month'
			@logs = Log.where('created_at > ?', 3.months.ago)
		elsif params[:stretch] == '6month'
			@logs = Log.where('created_at > ?', 6.months.ago)
		elsif params[:stretch] == 'year'
			@logs = Log.where('created_at > ?', 1.year.ago)
		else
			@logs = Log.where('created_at > ?', 24.hours.ago)
		end
			
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

	def recent_activity
		logs = Log.where('created_at > ?', 24.hours.ago).where('response_code = ?', '500').order(created_at: :desc).limit(10)
		render :json => { :status => true, :activity => log }, :status => 200
	end

end

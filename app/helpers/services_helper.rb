module ServicesHelper

	def get_action(action_id)
		action = Action.find_by_id(action_id)
	end

	def get_service_name(service_id)
		service = Service.find_by_id(service_id)
		return service.name
	end

	def check_incident_status(action_id)
		last_log = Log.where('action_id = ?', action_id).order(created_at: :desc).limit(1)
		puts "kaosbote"
		puts last_log.inspect
		if last_log[0].response_code == 200
			true
		else
			false
		end
	end

end

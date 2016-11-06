class Service < ApplicationRecord

	has_many :actions

	def self.check_all
		services =  self.all
		services.each do |service|
			self.check(service.id)
		end
	end

	def self.check(id)
		service = self.find(id)
		obj = Hash.new
		service.actions.each do |action|
			require 'net/http'
			require 'benchmark'
			# Cliente HTTP
			http = Net::HTTP.new('smtp.gasco.cl', 80)
			http.use_ssl = false
			obj["#{action.name}"] = Hash.new
			temp = Hash.new
			time = Benchmark.measure {
				begin
					response = http.post(service.wsdl.gsub("http://smtp.gasco.cl", "").gsub("?wsdl", ""), action.xml_body, { 'Content-Type' => 'text/xml; charset=utf-8', 'SOAPAction' => action.soap_action })
				rescue Timeout::Error => e
					temp = { code: response.code, body: e.message }
				else
					case response
					when Net::HTTPOK
						temp = { code: response.code, body: response.body }
					when Net::HTTPClientError
						temp = { code: response.code, body: "Error en el cliente." }
					when Net::HTTPInternalServerError
						temp = { code: response.code, body: "Error en el servidor." }
					end
				end
			}
			obj["#{action.name}"] = temp
			obj["#{action.name}"][:time] = time.real
			log = Log.new
			log.action_id = action.id
			log.response_code = obj["#{action.name}"][:code]
			if action.id != 43
				log.response_body = obj["#{action.name}"][:body]
			else
				log.response_body = "Respuesta muy larga para aser almacenada."
			end
			log.response_time = obj["#{action.name}"][:time]
			log.save
		end
	end

end

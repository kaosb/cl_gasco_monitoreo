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
		service.actions.where(status: true).each do |action|
			require 'net/http'
			require 'benchmark'
			# Cliente HTTP
			if service.id == 9
				# Parche para WS con URI diferente al resto.
				http = Net::HTTP.new('webservices.gasco.cl', 80)
				# Se incorporo un gsub en la linea 32 para el mismo fin.
			else
				http = Net::HTTP.new('smtp.gasco.cl', 80)
			end
			http.use_ssl = false
			obj["#{action.name}"] = Hash.new
			temp = Hash.new
			response = ""
			time = Benchmark.measure {
				begin
					response = http.post(service.wsdl.gsub("http://smtp.gasco.cl", "").gsub("http://webservices.gasco.cl", "").gsub("?wsdl", ""), action.xml_body, { 'Content-Type' => 'text/xml; charset=utf-8', 'SOAPAction' => action.soap_action })
				rescue Timeout::Error => e
					temp = { code: response.code, body: e.message }
				else
					case response
					when Net::HTTPOK
						# temp = { code: response.code, body: response.body }
						temp = { code: response.code, body: "Respuesta satisfactoria." }
					when Net::HTTPClientError
						temp = { code: response.code, body: "Error en el cliente." }
					when Net::HTTPInternalServerError
						temp = { code: response.code, body: "Error en el servidor." }
					end
				end
			}
			obj["#{action.name}"] = temp
			obj["#{action.name}"][:time] = time.real
			# Notificamos a los usuarios.
			if obj["#{action.name}"][:code].to_i > 200
				self.notify(action, response)
			end
			log = Log.new
			log.action_id = action.id
			log.response_code = obj["#{action.name}"][:code]
			log.response_body = obj["#{action.name}"][:body]
			log.response_time = obj["#{action.name}"][:time]
			log.save
		end
	end

	def self.notify(action, response)
		service = self.find(action.service_id)
		receivers = AlertReceiver.where(status: true)
		destinatarios = Array.new
		receivers.each do |receiver|
			destinatarios << {
				:name => receiver.name,
				:email => receiver.email
			}
		end
		body = "
		<html>
		<head></head>
			<body>
				<div>
					<p>Se presento un problema al corroborar la operacion del metodo <strong>#{action.name}</strong> correspondiente al servicio <strong>#{service.name}</strong>.</p>
				</div>
				<div>
					<p>por favor verificar y/o notificar a quien corresponda.</p>
				</div>
				<div>
					<p>
					<h3>La respuesta recibida desde el servicio fue:</h3>
					<code>
					#{response['Set-Cookie']}
					<br/>
					#{response.get_fields('set-cookie')}
					<br/>
					#{response.to_hash['set-cookie']}
					<br/>
					Headers: #{response.to_hash.inspect}
					<br/>
					Status:
					<br/>
					code: #{response.code}
					<br/>
					message: #{response.message}
					name: #{response.class.name}
					Body:
					#{response.body.force_encoding("UTF-8")}
					</code>
					</p>
				</div>
			</body>
		</html>
		"
		self.send_email("Alerta monitoreo", destinatarios, 'Para ver el correo de modo correcto es necesario verlo como HTML.', body)
	end

	def self.send_email(subject, to, text, html)
		require 'mandrill'  
		m = Mandrill::API.new 'oaZlASbjNEKovpXAwoAEfg'
		message = {
			:subject => subject,
			:from_name => 'Gasco watcher',
			:from_email => 'no-reply@coddea.com',
			:to => to,
			:text => text.force_encoding("UTF-8"),
			:html => html,
			:headers => { "Reply-To" => "soporte@coddea.com" }
		}
		sending = m.messages.send message  
		return sending
	end

	def self.send_push
	end

end

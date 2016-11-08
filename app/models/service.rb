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
			http = Net::HTTP.new('smtp.gasco.cl', 80)
			http.use_ssl = false
			obj["#{action.name}"] = Hash.new
			temp = Hash.new
			response = ""
			time = Benchmark.measure {
				begin
					response = http.post(service.wsdl.gsub("http://smtp.gasco.cl", "").gsub("?wsdl", ""), action.xml_body, { 'Content-Type' => 'text/xml; charset=utf-8', 'SOAPAction' => action.soap_action })
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
			# http.finish
		end
	end

	def self.notify(action, response)
		service = self.find(action.service_id)
		destinatarios = [
			{
				:name => 'Felipe I. González G.',
				:email => 'felipe@coddea.com'
			},
			{
				:name => 'Patricio Vasquez',
				:email => 'pvasquez@gasco.cl'
			}
		]
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
					<h3>El mensaje recibido desde el servicio fue:</h3>
					<pre><code><![CDATA[
					#{response.body}
					]]>
					</code></pre>
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
			:text => text,
			:html => html,
			:headers => { "Reply-To" => "soporte@coddea.com" }
		}
		sending = m.messages.send message  
		return sending
	end

	def self.send_push
	end

end

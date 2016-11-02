class ServicesController < ApplicationController

	# Controlador responsable de ejecutar las tareas referidas a los servicios y su monitoreo.

	# Bloque dedicado al servicio http://smtp.gasco.cl/WSGasco/WSRFCWeb/ConsultaServicio.asmx
	# define el prefijo wsrfcweb_consultaservicio para todas las funciones.

	def wsrfcweb_consultaservicio
		require 'savon'
		require 'benchmark'
		client = Savon.client(wsdl: 'http://smtp.gasco.cl/WSGasco/WSRFCWeb/ConsultaServicio.asmx?wsdl')
		time = Hash.new
		response = Hash.new
		# Llamo a los metodos del servicio
		time[:zzrfc_check_clte_documento] = Benchmark.measure {
			begin
				response[:zzrfc_check_clte_documento] = client.call(:zzrfc_check_clte_documento, message: { rfcparamf: { bukrs: 7000 , kunnr: 12002446 } })
			rescue Savon::SOAPFault => e
				response[:zzrfc_check_clte_documento] = { error: e.message }
			end
		}
		time[:zzrfc_getdeudas] = Benchmark.measure {
			begin
				response[:zzrfc_getdeudas] = client.call(:zzrfc_getdeudas, message: { zzrfc_getdeudas: { bukrs: 7000 , kunnr: 12287768 } })
			rescue Savon::SOAPFault => e
				response[:zzrfc_getdeudas] = { error: e.message }
			end
		}
		time[:zzrfc_getdeudas_v2] = Benchmark.measure {
			begin
				response[:zzrfc_getdeudas_v2] = client.call(:zzrfc_getdeudas_v2, message: { rfcparam: { bukrs: 7000 , kunnr: 12002446 } })
			rescue Savon::SOAPFault => e
				response[:zzrfc_getdeudas_v2] = { error: e.message }
			end
		}
		time[:zzrfc_getdeudas_v3] = Benchmark.measure {
			begin
				response[:zzrfc_getdeudas_v3] = client.call(:zzrfc_getdeudas_v3, message: { rfcparam: { bukrs: 7000 , kunnr: 12287768 } })
			rescue Savon::SOAPFault => e
				response[:zzrfc_getdeudas_v3] = { error: e.message }
			end
		}
		# Construyo la respuesta
		render json: { status: true, available_operations: client.operations, time: time, response: response }, status: 200
	end

	def wsrfcweb_consultaservicio_http
		require 'net/http'
		require 'benchmark'
		time = Hash.new
		response = Hash.new
		# Cliente HTTP
		http = Net::HTTP.new('smtp.gasco.cl', 80)
		http.use_ssl = false
		# Datos de prueba
		division = 7000
		numero_cliente = 12287768
		# Llamo a los metodos del servicio
		# time[:zzrfc_check_clte_documento] = Benchmark.measure {
		# 	begin
		# 		xml_body = "<x:Envelope xmlns:x='http://schemas.xmlsoap.org/soap/envelope/' xmlns:rfc='http://smtp.gasco.cl/WSGasco/RFCWeb/'>
		# 			<x:Header/>
		# 			<x:Body>
		# 				<rfc:ZZRFC_CheckClteDocumento>
		# 					<rfc:sociedad>0</rfc:sociedad>
		# 					<rfc:nrocliente>0</rfc:nrocliente>
		# 					<rfc:nrodoc>0</rfc:nrodoc>
		# 				</rfc:ZZRFC_CheckClteDocumento>
		# 			</x:Body>
		# 		</x:Envelope>"
		# 		resp = http.post("/WSGasco/WSRFCWeb/ConsultaServicio.asmx", xml_body, { 'Content-Type' => 'text/xml; charset=utf-8', 'SOAPAction' => 'http://smtp.gasco.cl/WSGasco/RFCWeb/ZZRFC_CheckClteDocumento' })
		# 		response[:zzrfc_check_clte_documento] = resp.body
		# 	rescue StandardError => e
		# 		response[:zzrfc_check_clte_documento] = { error: e.message }
		# 	end
		# }
		# time[:zzrfc_getdeudas] = Benchmark.measure {
		# 	begin
		# 		xml_body = "<x:Envelope xmlns:x='http://schemas.xmlsoap.org/soap/envelope/' xmlns:rfc='http://smtp.gasco.cl/WSGasco/RFCWeb/'>
		# 			<x:Header/>
		# 			<x:Body>
		# 				<rfc:Zzrfc_Getdeudas>
		# 					<rfc:BUKRS>#{division}</rfc:BUKRS>
		# 					<rfc:KUNNR>#{numero_cliente}</rfc:KUNNR>
		# 				</rfc:Zzrfc_Getdeudas>
		# 			</x:Body>
		# 		</x:Envelope>"
		# 		resp = http.post("/WSGasco/WSRFCWeb/ConsultaServicio.asmx", xml_body, { 'Content-Type' => 'text/xml; charset=utf-8', 'SOAPAction' => 'http://smtp.gasco.cl/WSGasco/RFCWeb/Zzrfc_Getdeudas' })
		# 		response[:zzrfc_getdeudas] = resp.body
		# 	rescue StandardError => e
		# 		response[:zzrfc_getdeudas] = { error: e.message }
		# 	end
		# }
		# time[:zzrfc_getdeudas_v2] = Benchmark.measure {
		# 	begin
		# 		xml_body = "<x:Envelope xmlns:x='http://schemas.xmlsoap.org/soap/envelope/' xmlns:rfc='http://smtp.gasco.cl/WSGasco/RFCWeb/'>
		# 			<x:Header/>
		# 			<x:Body>
		# 				<rfc:ZZRFC_GETDEUDAS_V2>
		# 					<rfc:rfcparam>
		# 						<rfc:BUKRS>#{division}</rfc:BUKRS>
		# 						<rfc:KUNNR>#{numero_cliente}</rfc:KUNNR>
		# 					</rfc:rfcparam>
		# 				</rfc:ZZRFC_GETDEUDAS_V2>
		# 			</x:Body>
		# 		</x:Envelope>"
		# 		resp = http.post("/WSGasco/WSRFCWeb/ConsultaServicio.asmx", xml_body, { 'Content-Type' => 'text/xml; charset=utf-8', 'SOAPAction' => 'http://smtp.gasco.cl/WSGasco/RFCWeb/ZZRFC_GETDEUDAS_V2' })
		# 		response[:zzrfc_getdeudas_v2] = resp.body
		# 	rescue StandardError => e
		# 		response[:zzrfc_getdeudas_v2] = { error: e.message }
		# 	end
		# }
		time[:zzrfc_getdeudas_v3] = Benchmark.measure {
			begin
				xml_body = "<x:Envelope xmlns:x='http://schemas.xmlsoap.org/soap/envelope/' xmlns:rfc='http://smtp.gasco.cl/WSGasco/RFCWeb/'>
					<x:Header/>
					<x:Body>
						<rfc:ZZRFC_GETDEUDAS_V3>
							<rfc:rfcparam>
								<rfc:BUKRS>#{division}</rfc:BUKRS>
								<rfc:KUNNR>#{numero_cliente}</rfc:KUNNR>
							</rfc:rfcparam>
						</rfc:ZZRFC_GETDEUDAS_V3>
					</x:Body>
				</x:Envelope>"
				response = http.post("/WSGasco/WSRFCWeb/ConsultaServicio.asmx", xml_body, { 'Content-Type' => 'text/xml; charset=utf-8', 'SOAPAction' => 'http://smtp.gasco.cl/WSGasco/RFCWeb/ZZRFC_GETDEUDAS_V3' })
			rescue Timeout::Error => e
				response[:zzrfc_getdeudas_v3] = { code: response.code, body: e.message }
			else
				case response
				when Net::HTTPOK
					response[:zzrfc_getdeudas_v3] = { code: response.code, body: response.body }
				when Net::HTTPClientError
					response[:zzrfc_getdeudas_v3] = { code: response.code, body: "Error en el cliente." }
				when Net::HTTPInternalServerError
					response[:zzrfc_getdeudas_v3] = { code: response.code, body: "Error en el servidor." }
				end
			end
		}
		# Construyo la respuesta
		render json: { status: true, time: time, response: response }, status: 200
	end

end

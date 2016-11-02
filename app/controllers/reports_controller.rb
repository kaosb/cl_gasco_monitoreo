class ReportsController < ApplicationController

	# Ejemplo call servicio.
	def dashboard
		require 'savon'
		client = Savon.client(wsdl: 'http://smtp.gasco.cl/WSGasco/WSPedidosOnline/WSGranelSimula.asmx?wsdl')
		response = client.call(:get_sector_direccion, message: { codigo_cliente: 12287887, tipo_pedido: "G", v_korg: "7200" })
		render json: { status: true, available_operations: client.operations, response: response.body }, status: 200
	end

	# def rfcweb_concept_tet
	def rfcweb
		require 'savon'
		require 'benchmark'
		client = Savon.client(wsdl: 'http://smtp.gasco.cl/WSGasco/WSRFCWeb/ConsultaServicio.asmx?wsdl')
		time = Array.new
		response = Array.new
		# Llamo a los metodos del servicio
		time << Benchmark.measure {
			begin
				response <<  client.call(:zzrfc_check_clte_documento, message: { rfcparamf: { bukrs: 7000 , kunnr: 12002446 } })
			rescue  Exception => e
				response << { msg: e.message}
			end
		}
		time << Benchmark.measure {
			begin
				response <<  client.call(:zzrfc_getdeudas, message: { zzrfc_getdeudas: { bukrs: 7000 , kunnr: 12287768 } })
			rescue  Savon::SOAPFault => e
				response << { msg: e.message}
			end
		}
		time << Benchmark.measure {
			begin
				response <<  client.call(:zzrfc_getdeudas_v2, message: { rfcparam: { bukrs: 7000 , kunnr: 12002446 } })
			rescue  Exception => e
				response << { msg: e.message}
			end
		}
		time << Benchmark.measure {
			begin
				ble = client.call(:zzrfc_getdeudas_v3, message: { rfcparam: { bukrs: 7000 , kunnr: 12287768 } })
				response << ble.to_xml
			rescue  Exception => e
				response << { msg: e.message}
			end
		}
		time << Benchmark.measure {
			begin
				# response <<  client.call(:zzrfc_getdeudas_v3, message: { rfcparam: { bukrs: 7000 , kunnr: 12287768 } })
				require 'net/http'
				division = 7000
				numero_cliente = 12287768
				xml = "<x:Envelope xmlns:x='http://schemas.xmlsoap.org/soap/envelope/' xmlns:rfc='http://smtp.gasco.cl/WSGasco/RFCWeb/'>
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
				http = Net::HTTP.new('smtp.gasco.cl', 80)
				http.use_ssl = false
				resp = http.post("/WSGasco/WSRFCWeb/ConsultaServicio.asmx", xml, { 'Content-Type' => 'text/xml; charset=utf-8', 'SOAPAction' => 'http://smtp.gasco.cl/WSGasco/RFCWeb/ZZRFC_GETDEUDAS_V3' })
				response << resp.body
			rescue  Exception => e
				response << { msg: e.message}
			end
		}
		# Construyo la respuesta
		render json: { status: true, available_operations: client.operations, response: response }, status: 200
	end

	def index
		@cases = Array.new
	end

end

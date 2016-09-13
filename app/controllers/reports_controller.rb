class ReportsController < ApplicationController

	# Ejemplo call servicio.
	def dashboard
		require 'savon'
		client = Savon.client(wsdl: 'http://smtp.gasco.cl/WSGasco/WSPedidosOnline/WSGranelSimula.asmx?wsdl')
		response = client.call(:get_sector_direccion, message: { codigo_cliente: 12287887, tipo_pedido: "G", v_korg: "7200" })
		render json: { status: true, available_operations: client.operations, response: response.body }, status: 200
	end

	def index
		@cases = Array.new
	end

end

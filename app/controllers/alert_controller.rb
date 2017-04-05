class AlertController < ApplicationController

	def index
		@receivers = AlertReceiver.all
	end

	# metodo para agregar un receptor de alertas via ajax.
	def add_alert_receiver
		if !params[:name].nil? && !params[:email].nil?
			receiver = AlertReceiver.find_or_create_by(name: params[:name], email: params[:email])
			receiver.platform_email = 1
			receiver.status = 1
			receiver.save
			render :json => { :status => true, :message => "El receptor fue creado.", :receiver => receiver }, :callback => params[:callback], :status => 200
		else
			render :json => { :status => false, :message => "Parmetros insuficientes." }, :callback => params[:callback], :status => 200
		end
	end

	def delete_alert_receiver
		if !params[:receiver_id].nil?
			receiver = AlertReceiver.delete(params[:receiver_id])
			render :json => { :status => true, :message => "El receptor fue eliminado.", :receiver => receiver }, :callback => params[:callback], :status => 200
		else
			render :json => { :status => false, :message => "Parmetros insuficientes." }, :callback => params[:callback], :status => 200
		end
	end

	def edit_alert_receiver
		@receiver = AlertReceiver.find_by_id(params[:id])
	end

end

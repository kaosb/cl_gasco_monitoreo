class AlertController < ApplicationController

	def index
		@receivers = AlertReceiver.all
	end

end

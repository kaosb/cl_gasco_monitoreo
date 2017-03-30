class AlertController < ApplicationController

	def index
		@receivers = AlertReceivers.all
	end

end

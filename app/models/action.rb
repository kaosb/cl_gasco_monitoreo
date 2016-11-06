class Action < ApplicationRecord

	has_many :logs
	belongs_to :services

end

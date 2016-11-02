class CreateServices < ActiveRecord::Migration[5.0]
	def change
		create_table :services do |t|
			t.string :name
			t.string :description
			t.string :wsdl
			t.timestamps
			t.boolean :status, default: 1
		end
	end
end

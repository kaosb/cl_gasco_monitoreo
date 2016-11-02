class CreateActions < ActiveRecord::Migration[5.0]
	def change
		create_table :actions do |t|
			t.integer :service_id, :null => false
			t.string :name
			t.string :description
			t.text :xml_body
			t.text :xml_spected_body
			t.string :soap_action
			t.timestamps
			t.boolean :status, default: 1
		end
	end
end

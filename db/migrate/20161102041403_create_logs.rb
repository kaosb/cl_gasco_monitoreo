class CreateLogs < ActiveRecord::Migration[5.0]
	def change
		create_table :logs do |t|
			t.integer :action_id, :null => false
			t.integer :response_code
			t.text :response_body
			t.timestamps
		end
	end
end

class CreateAlertReceivers < ActiveRecord::Migration[5.0]
	def change
		create_table :alert_receivers do |t|
			t.string :name
			t.string :email, null: false
			t.boolean :platform_email, default: 1, null: true
			t.boolean :platform_mobile, default: 0, null: true
			t.timestamps null: false
			t.boolean :status, default: 1, null: true
		end
	end
end

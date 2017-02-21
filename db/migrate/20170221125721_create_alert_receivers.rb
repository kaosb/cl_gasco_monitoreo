class CreateAlertReceivers < ActiveRecord::Migration[5.0]
  def change
    create_table :alert_receivers do |t|

      t.timestamps
    end
  end
end

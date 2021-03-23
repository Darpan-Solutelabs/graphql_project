class CreateAppointments < ActiveRecord::Migration[6.1]
  def change
    create_table :appointments do |t|
      t.bigint :doctor_id
      t.bigint :patient_id
      t.datetime :date
      t.string :reason
      t.boolean :accepted

      t.timestamps
    end

    add_index :appointments, :doctor_id
    add_index :appointments, :patient_id
    add_index :appointments, [:doctor_id, :patient_id]
  end
end

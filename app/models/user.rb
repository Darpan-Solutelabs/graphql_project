class User < ApplicationRecord
  rolify
  has_secure_password

  has_many :recieved_appointments, class_name: "Appointment", foreign_key: "doctor_id"
  has_many :applied_appointments, class_name: "Appointment", foreign_key: "patient_id"
  has_many :doctors, through: :applied_appointments, source: :doctor
  has_many :patients, through: :recieved_appointments, source: :patient
end

class Appointment < ApplicationRecord


    belongs_to :doctor, class_name: "User"
    belongs_to :patient, class_name: "User"

    validates :doctor_id, presence: true
    validates :patient_id, presence: true
    validates :date, presence: true
    validates :reason, presence: true
    validate :check_if_appointment_is_already_there
    validate :check_if_date_is_not_passed

    def check_if_appointment_is_already_there
        appointment = Appointment.where(doctor_id: self.doctor_id, patient_id: self.patient_id, date: self.date)
        if !appointment.empty?
            errors.add(:date, "Appointment with #{self.doctor.name} is already registered")
        end
    end

    def check_if_date_is_not_passed
        if self.date < Time.now
            errors.add(:date, "Please enter valid date")
        end
    end
end

module Mutations
  class CreateAppointment < BaseMutation
    
    argument :doctor_id, Integer, required: false
    argument :date, String, required: false
    argument :reason, String, required: false

    field :appointment, Types::AppointmentType, null: true

    def resolve(doctor_id:, date:, reason:)
      binding.pry
      raise GraphQL::ExecutionError.new("User is not signed in", options: {status: :unauthorized}) if !context[:current_user]
      raise GraphQL::ExecutionError.new("Doctor can not create appointment", options: {status: :unauthorized}) if context[:current_user].is_doctor?
      raise GraphQL::ExecutionError.new("Patient can not assign as a doctor", options: {status: :unauthorized}) if User.find_by_id(doctor_id).is_patient?
      appointment = Appointment.create!(
        doctor_id: doctor_id,
        patient_id: context[:current_user].id,
        date: date,
        reason: reason
      )
      { appointment: appointment }
    end
  end
end

module Mutations
  class CreateAppointment < BaseMutation
    
    argument :doctor_id, Integer, required: true
    argument :date, String, required: true
    argument :reason, String, required: true

    field :appointment, Types::AppointmentType, null: true

    def resolve(doctor_id:, date:, reason:)
      raise GraphQL::ExecutionError.new(I18n.t('token_missing'), options: {status: :unauthorized}) if !context[:current_user]
      raise GraphQL::ExecutionError.new(I18n.t('doctor_create_appointment'), options: {status: :unauthorized}) if context[:current_user].is_doctor?
      raise GraphQL::ExecutionError.new(I18n.t('doctor_as_patient'), options: {status: :unauthorized}) if User.find_by_id(doctor_id).is_patient?
      appointment = Appointment.new(
        doctor_id: doctor_id,
        patient_id: context[:current_user].id,
        date: date,
        reason: reason
      )
      if appointment.save
        { appointment: appointment }
      else
        raise GraphQL::ExecutionError.new(appointment.errors.full_messages)
      end
    end
  end
end

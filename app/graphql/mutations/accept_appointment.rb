module Mutations
  class AcceptAppointment < BaseMutation
    
    argument :option, String, required: false
    argument :appointment_id, Integer, required: false

    field :message, String, null: true

    def resolve(option:, appointment_id:)
      raise GraphQL::ExecutionError.new(I18n.t('token_missing'), options: {status: :unauthorized}) if !context[:current_user]
      raise GraphQL::ExecutionError.new(I18n.t('invalid'), options: {status: :invalid}) if option != 'accept' && option!= 'reject'
      appointment = Appointment.find_by_id(appointment_id)
      raise GraphQL::ExecutionError.new(I18n.t('doctor_approve_appointment'), options: {status: :unauthorized}) if appointment.doctor.id != context[:current_user].id
      
      
      if appointment
        HospitalMailer.appointment_confirmation(appointment, option).deliver_later
        if option == 'accept'
          appointment.update(accepted: true)
          appointment.save
          { message: I18n.t('appointment_accept') }
        else
          appointment.upadate(accepted: false)
          { message: I18n.t('appointment_reject') }
        end
      else
        raise GraphQL::ExecutionError.new(I18n.t('id_invalid'), options: {status: :invalid})
      end 
    end
  end
end

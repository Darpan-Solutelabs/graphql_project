module Mutations
  class AcceptAppointment < BaseMutation
    
    argument :option, String, required: false
    argument :appointment_id, Integer, required: false

    field :message, String, null: true

    def resolve(option:, appointment_id:)
      raise GraphQL::ExecutionError.new('Authorization token is missing', options: {status: :unauthorized}) if !context[:current_user]
      raise GraphQL::ExecutionError.new('Option is invalid', options: {status: :invalid}) if option != 'accept' && option!= 'reject'
      appointment = Appointment.find_by_id(appointment_id)
      raise GraphQL::ExecutionError.new('Only Doctor can approve or reject the appointment', options: {status: :unauthorized}) if appointment.doctor.id != context[:current_user].id
      
      
      if appointment
        HospitalMailer.appointment_confirmation(appointment, option).deliver_later
        if option == 'accept'
          appointment.update(accepted: true)
          appointment.save
          { message: 'Appointment accepted successfully' }
        else
          appointment.upadate(accepted: false)
          { message: 'Appointment rejected successfully' }
        end
      else
        raise GraphQL::ExecutionError.new('Appointment id is invalid', options: {status: :invalid})
      end 
    end
  end
end

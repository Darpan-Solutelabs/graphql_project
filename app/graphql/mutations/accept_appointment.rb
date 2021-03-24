module Mutations
  class AcceptAppointment < BaseMutation
    
    argument :option, String, required: false
    argument :appointment_id, Integer, required: false

    field :message, String, null: true

    def resolve(option:, appointment_id:)
      if context[:current_user].is_doctor?
        if option != 'accept' && option!= 'reject'
          GraphQL::ExecutionError.new('Option is invalid', options: {status: :invalid})
        end
        appointment = Appointment.find_by_id(appointment_id)
        if appointment
          HospitalMailer.appointment_confirmation(appointment, option).deliver_later
          if option == 'accept'
            appointment.update(accepted: true)
            { message: 'Appointment accepted successfully' }
          else
            appointment.upadate(accepted: false) if option == 'reject'
            { message: 'Appointment rejected successfully' }
          end
        else
          GraphQL::ExecutionError.new('Appointment id is invalid', options: {status: :invalid})
        end
      else
        GraphQL::ExecutionError.new('Only Doctor can approve or reject the appointment', options: {status: :unauthorized})
      end
    end

  end
end

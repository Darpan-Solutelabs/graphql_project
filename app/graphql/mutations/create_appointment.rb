module Mutations
  class CreateAppointment < BaseMutation
    
    argument :doctor_id, Integer, required: false
    argument :date, String, required: false
    argument :reason, String, required: false

    field :appointment, Types::AppointmentType, null: true

    def resolve(doctor_id:, date:, reason:)
      binding.pry
      if context[:current_user]
        if context[:current_user].is_patient?
          if User.find_by_id(doctor_id).is_patient?
            GraphQL::ExecutionError.new("Patient can not assign as a doctor", options: {status: :unauthorized}) 
          end
          appointment = Appointment.create!(
            doctor_id: doctor_id,
            patient_id: context[:current_user].id,
            date: date,
            reason: reason
          )
          { appointment: appointment }
        else
          GraphQL::ExecutionError.new("Doctor can not create appointment", options: {status: :unauthorized})  
        end
      else
        GraphQL::ExecutionError.new("User is not signed in", options: {status: :unauthorized})
      end
    end

  end
end

module Mutations
  class SendConsultation < BaseMutation

    argument :patient_id, Integer, required: false
    argument :note, String, required: false

    field :message, String, null: false

    def resolve(patient_id:, note:)
      raise GraphQL::ExecutionError.new("Token is Empty") if !context[:current_user]
      raise GraphQL::ExecutionError.new("Can not access this link") if context[:current_user].is_patitent?
      patient = User.find_by_id patient_id
      raise GraphQL::ExecutionError.new("Invalid Patient") if !patient || patient.is_docotr?
      HospitalMailer.send_consultation(context[:current_user], patient, note).deliver_later
      { message: "Email sent successfully" }
    end
  end
end

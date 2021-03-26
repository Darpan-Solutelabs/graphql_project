module Mutations
  class SendConsultation < BaseMutation

    argument :patient_id, Integer, required: false
    argument :note, String, required: false

    field :message, String, null: false

    def resolve(patient_id:, note:)
      raise GraphQL::ExecutionError.new(I18n.t('token_missing')) if !context[:current_user]
      raise GraphQL::ExecutionError.new(I18n.t('unauthorized')) if context[:current_user].is_patitent?
      patient = User.find_by_id patient_id
      raise GraphQL::ExecutionError.new(I18n.t('id_invalid')) if !patient || patient.is_docotr?
      HospitalMailer.send_consultation(context[:current_user], patient, note).deliver_later
      { message: I18n.t('email_success') }
    end
  end
end

module Mutations
  class UpdateUser < BaseMutation
    argument :id, Int, required: true
    argument :name, String, required: true
    argument :email, String, required: true
    argument :contact, String, required: true
    argument :address, String, required: true
    argument :password, String, required: true

    field :user, Types::UserType, null: true

    def resolve(id:, **attributes)
      raise GraphQL::ExecutionError.new(I18n.t('token_missing'), options: {status: :unauthorized}) if !context[:current_user]
      raise GraphQL::ExecutionError.new(I18n.t('id_invalid'), options: {status: :unauthorized}) if context[:current_user].id != id
      if context[:current_user].update(attributes)
        { user: context[:current_user] }
      else
        raise GraphQL::ExecutionError.new(context[:current_user].errors.full_messages)
      end
    end

  end
end

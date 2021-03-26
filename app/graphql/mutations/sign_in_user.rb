module Mutations
  class SignInUser < BaseMutation

    argument :email, String, required: false
    argument :password, String, required: false

    field :token, String, null: true
    field :user, Types::UserType, null: true

    def resolve(email:, password:)
      user = User.find_by_email(email)
      if user && user.authenticate(password)
        { token: user.generate_jwt, user: user }
      else
        GraphQL::ExecutionError.new(I18n.t('signin_invalid'), options: {status: :invalid, status: 402})
      end
    end

  end
end

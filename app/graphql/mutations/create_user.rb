module Mutations
  class CreateUser < BaseMutation
    
    argument :name, String, required: false
    argument :email, String, required: false
    argument :contact, String, required: false
    argument :address, String, required: false
    argument :password, String, required: false
    argument :role, Integer, required: true

    field :token, String, null: true
    field :user, Types::UserType, null: true

    def resolve(name:, email:, contact:, address:, password:, role:)
      user = User.new(
        name: name,
        email: email,
        contact: contact,
        address: address,
        password: password
      )

      if user.save
        roles = [:doctor, :patient]

        user.add_role roles[role]

        token = user.generate_jwt
        {token: token, user: user}
      else
        raise GraphQL::ExecutionError.new(user.errors.full_messages)
      end
    end
  end
end

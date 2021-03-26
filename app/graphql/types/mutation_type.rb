module Types
  class MutationType < Types::BaseObject
    field :update_user, mutation: Mutations::UpdateUser
    field :send_consultation, mutation: Mutations::SendConsultation
    field :accept_appointment, mutation: Mutations::AcceptAppointment
    field :create_appointment, mutation: Mutations::CreateAppointment
    field :sign_in_user, mutation: Mutations::SignInUser
    field :create_user, mutation: Mutations::CreateUser
    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World"
    end
  end
end

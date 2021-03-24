module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.
    field :all_user, UserType.connection_type, null: false
    def all_user
      if context[:current_user]
        User.all
      else
        GraphQL::ExecutionError.new("Unauthorized Error", options: {status: :unauthorized, code: 401})
      end
    end

    field :all_appointment, AppointmentType.connection_type, null: false
    def all_appointment
      Appointment.all
    end
    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World!"
    end
  end
end

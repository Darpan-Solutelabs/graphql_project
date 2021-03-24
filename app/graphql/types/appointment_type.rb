module Types
  class AppointmentType < Types::BaseObject
    field :id, ID, null: false
    field :doctor, UserType, null: true
    field :patient, UserType, null: true
    field :date, GraphQL::Types::ISO8601DateTime, null: true
    field :reason, String, null: true
    field :accepted, Boolean, null: true
  end
end

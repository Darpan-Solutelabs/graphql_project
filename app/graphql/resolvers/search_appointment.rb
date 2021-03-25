require 'search_object'
require 'search_object/plugin/graphql'

class Resolvers::SearchAppointment < GraphQL::Schema::Resolver

    include SearchObject.module (:graphql)
    
    scope { if context[:current_user] 
                context[:current_user]
            else 
                raise GraphQL::ExecutionError.new('Token is Empty', options: { status: :unauthorized }) 
            end
        }

    type Types::AppointmentType.connection_type, null: false

    class FilterEnum < Types::BaseEnum
        graphql_name 'FilterAppointment'

        value 'AllAppointment'
        value 'RejectedAppointment'
        value 'AcceptedAppointment'
        value 'newAppointment'
    end

    option :filter, type: FilterEnum, required: false
    option :id, type: types.Int, required: false, with: :apply_filter_with_id

    def apply_filter_with_id(scope, value)
        if scope.is_doctor?
            scope.recieved_appointments.where id: value
        else
            scope.applied_appointments.where id: value
        end
    end

    def apply_filter_with_all_appointment(scope)
        if scope.is_doctor?
            scope.recieved_appointments
        else
            scope.applied_appointments
        end
    end

    def apply_filter_with_accepted_appointment(scope)
        if scope.is_doctor?
            scope.recieved_appointments.where accepted: true
        else
            scope.applied_appointments.where accepted: true
        end
    end

    def apply_filter_with_rejected_appointment(scope)
        if scope.is_doctor?
            scope.recieved_appointments.where accepted: false
        else
            scope.applied_appointments.where accepted: false
        end
    end

    def apply_filter_with_new_appointment(scope)
        if scope.is_doctor?
            scope.recieved_appointments.where accepted: nil
        else
            scope.applied_appointments.where accepted: nil
        end
    end

end
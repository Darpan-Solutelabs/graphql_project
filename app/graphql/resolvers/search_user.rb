require 'search_object'
require 'search_object/plugin/graphql'

class Resolvers::SearchUser < GraphQL::Schema::Resolver

    include SearchObject.module(:graphql)

    scope { if context[:current_user]
                context[:current_user]
            else
                raise GraphQL::ExecutionError.new("Token is missing", options: {status: :unauthorized})
            end
          }

    type Types::UserType.connection_type, null: false

    class FilterEnum < Types::BaseEnum
        graphql_name 'FilterUser'

        value 'Patients'
        value 'Doctors'
        value 'AllDoctors'
    end

    option :filter, type: FilterEnum, required: false
    option :id, type: types.Int, required: false, with: :apply_filter_with_id

    def apply_filter_with_id(scope, value)
        user = User.where id: value
        if (scope.id == user[0].id) || (scope.is_doctor? && user[0].is_patient?) || (scope.is_patient? && user[0].is_doctor?)
            return user
        end
        GraphQL::ExecutionError.new("You can not access this user", options: { status: :unauthorized })
    end


    def apply_filter_with_patients(scope)
        if scope.is_doctor?
            scope.patients
        else
            raise_error
        end
    end

    def apply_filter_with_doctors(scope)
        binding.pry
        if scope.is_patient?
            scope.doctors
        else
            raise_error
        end
    end

    def apply_filter_with_all_doctors(scope)
        if scope.is_patient?
            Role.find_by_name("doctor").users
        else
            raise_error
        end
    end

    def raise_error
        GraphQL::ExecutionError.new("Invalid Argument", options: { status: :invalid })
    end
end
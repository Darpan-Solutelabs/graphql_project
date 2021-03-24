class HospitalMailer < ApplicationMailer
    def appointment_confirmation(appointment, option)
        @appointment = appointment
        @option = option
        if option == "accept"
            subject = "Your appointment is accepted"
        else
            subject = "Your appointment is rejected"
        end
        mail to: appointment.patient.email, subject: subject
    end
end

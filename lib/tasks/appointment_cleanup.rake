namespace :appointment_cleanup do
    desc "cleanup for appointment"
    task :delete => :environment do
        Appointment.where("date < ? AND (accepted = null OR accepted = false)", Time.now).destroy_all
    end
end

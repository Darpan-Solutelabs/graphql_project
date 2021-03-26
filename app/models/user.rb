class User < ApplicationRecord
  rolify
  has_secure_password

  has_many :recieved_appointments, class_name: "Appointment", foreign_key: "doctor_id", dependent: :destroy
  has_many :applied_appointments, class_name: "Appointment", foreign_key: "patient_id", dependent: :destroy
  has_many :doctors, through: :applied_appointments, source: :doctor
  has_many :patients, through: :recieved_appointments, source: :patient

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 }, 
                      format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                      uniqueness: true
  validates :address, presence: true, length: { maximum: 250 }
  validates :contact, presence: true, length: { is: 10 }, numericality: { only_integer: true }
  validates :password, presence: true, length: { minimum: 6, maximum: 12 }

  def generate_jwt
    JWT.encode({id: id, exp: 60.days.from_now.to_i}, Rails.application.secrets.secret_key_base)
  end

end

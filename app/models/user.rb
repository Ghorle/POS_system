class User < ApplicationRecord
  has_one_attached :profile
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  has_many :my_orders, class_name: "Order", foreign_key: "employee_id", dependent: :nullify
end

class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :omniauthable
  include DeviseTokenAuth::Concerns::User

  has_many :notifications
  has_many :devices
  has_many :memberships, class_name: "Member"
end

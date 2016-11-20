class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :omniauthable
  include DeviseTokenAuth::Concerns::User

  has_many :notifications
end

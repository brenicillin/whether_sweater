class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :password_confirmation, presence: true
  
  has_secure_password
  before_create :generate_api
  
  private 
  
  def generate_api
    self.api_key = SecureRandom.hex(12)
  end
end
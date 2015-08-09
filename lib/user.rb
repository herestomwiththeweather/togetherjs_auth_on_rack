require 'active_record'
require 'bcrypt'

class User < ActiveRecord::Base
  attr_accessor :password
  validates :email, uniqueness: true, presence: true
  validates_confirmation_of :password

  before_save :encrypt_password

  def self.authenticate(email, password)
    u = User.where(email: email).first
    u && u.password_hash == BCrypt::Engine.hash_secret(password, u.password_salt) ? u : nil
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    else
      raise "password required"
    end
  end
end

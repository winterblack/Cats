# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require 'bcrypt'
class User < ActiveRecord::Base
  validates :username, :password_digest, presence: true
  validates :session_token, :username, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true}
  attr_reader :password
  has_many :cats
  has_many :cat_rental_requests

  def self.find_by_credentials(username, password)
    user = User.find_by_username(username)
    user.try(:valid_password?, password) ? user : nil
  end

  def valid_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def reset_session_token
    self.session_token = SecureRandom.urlsafe_base64
    self.save!
    self.session_token
  end
end

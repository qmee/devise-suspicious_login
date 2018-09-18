class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :authenticatable, :trackable, :suspicious_login

  has_many :ip_addresses

  def suspicious_login_attempt?(request = nil)
    email.include?("suspicious")
  end
end

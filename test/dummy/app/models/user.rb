class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :suspicious_login

  has_many :ip_addresses

  def is_suspicious?(val)
    !!val
  end

  def send_devise_notification(method, raw=nil, *args)
    Thread.current[:token] = raw
  end
end

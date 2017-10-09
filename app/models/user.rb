class User < ApplicationRecord

  validates :nickname, :presence => true
  validates :email, :presence => true, uniqueness: true
  has_many :authentications
  # validates :login, :presence => true, :uniqueness => true

  # attr_accessor :password
  # before_save :generate_password
  accepts_nested_attributes_for :authentications

  class << self
    def from_auth(auth)
      Authentication.find_by_provider_and_uid(auth[:provider],
                                              auth[:uid]).try(:user) ||
        create!(
            :nickname => auth[:info][:nickname],
            :email => auth[:info][:email],
            :authentications_attributes => [
                Authentication.new(:provider => auth[:provider],
                                   :uid => auth[:uid]).attributes
            ]
        )
    end
  end

  def password
    @password
  end

  def password=(pass)
    return unless pass
    @password = pass
    generate_password(pass)
  end

  def self.authentication(login, password)
    user = User.find_by_login(login)
    if user && Digest::SHA256.hexdigest(password + user.salt) == user.hashed_password
      return user
    end
    false
  end

  private

  def generate_password(pass)
    salt = Array.new(10){rand(1024).to_s(36)}.join
    self.salt = salt
    self.hashed_password = Digest::SHA256.hexdigest(pass + salt)
  end
end

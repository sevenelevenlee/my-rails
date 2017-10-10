class User < ApplicationRecord

  validates :nickname, :presence => true
  validates :email, :presence => true, uniqueness: true
  has_many :authentications
  has_many :posts
  # validates :login, :presence => true, :uniqueness => true

  # attr_accessor :password
  # before_save :generate_password
  accepts_nested_attributes_for :authentications

  #白名单保护
  # attr_accessible :nickname, :eamil
  #黑名单
  # attr_protected :admin

  class << self
    def from_auth(auth)
      locate_auth(auth) || locate_email(auth) || create_auth(auth)
    end

    def locate_auth(auth)
      Authentication.find_by_provider_and_uid(auth[:provider],
                                              auth[:uid]).try(:user)
    end

    def locate_email(auth)
      user = find_by_email(auth[:info][:email])
      return unless user
      user.add_auth(auth)
      user
    end

    def create_auth(auth)
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

  def add_auth(auth)
    authentications.create(:provider => auth[:provider],
                           :uid => auth[:uid])
  end

  def password
    @password
  end

  #生成密文密码
  def password=(pass)
    return unless pass
    @password = pass
    generate_password(pass)
  end

  #验证登陆
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

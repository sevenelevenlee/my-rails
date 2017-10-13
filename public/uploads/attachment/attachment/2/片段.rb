class VerificationCode < ApplicationRecord
  validates_uniqueness_of :code

  def self.available_verification(code)
    verification_code = VerificationCode.where(code: code, used: false)
                          .order(expired_at: :desc).try(:first)
    if verification_code.present? && verification_code.expired_at > Time.now
      verification_code
    else
      nil
    end
  end

  def self.create_item(phone_number)
    verification_code = nil
    5.times do
      verification_code = VerificationCode.new(phone_number: phone_number,
                           code: get_code, used: false, expired_at: Time.now + 5.minutes)
      break if verification_code.save
    end
    verification_code
  end

  private

  def self.get_code
    random_number = rand(999999)
    '0' * (6 - random_number.to_s.length) + random_number.to_s
  end
end

####22222
class User < ApplicationRecord

  attr_accessor :verification_code
  attr_accessor :merchant_id
  attr_accessor :store_id

  mount_uploader :avatar, AvatarUploader

  has_many :authentications

  belongs_to :store_user

  has_many :orders

  enum sex: { male: 1, female: 2 }

  validates_presence_of :phone
  validates_presence_of :verification_code, on: :create
  validates_confirmation_of :password
  validates_format_of :password, :with => /[0-9a-zA-Z]{6,20}/, allow_blank: true
  validates_numericality_of :phone
  validates_length_of :phone, is: 11
  validates_uniqueness_of :phone
  validate :available_verification_code, on: :create
  validate :update_verification_code, on: :update
  validate :merchant_id_exists, on: :create
  validate :store_id_exists, on: :create


  def update_password(password)
    self.password = password
    self.save(validate: false)
  end

  def send_devise_notification(notification, *args)
    return true if notification == :reset_password_instructions
  end

  def send_reset_password_instructions
    set_reset_password_token
  end

  private

  def available_verification_code
    verification_code_item = VerificationCode.available_verification(verification_code)
    if verification_code_item.present?
      verification_code_item.update_attribute(:used, true)
    else
      errors.add(:verification_code, "验证码错误或已使用")
    end
  end

  def update_verification_code
    available_verification_code unless self.phone_was == self.phone
  end

  def merchant_id_exists
    merchant = Merchant.find_by(id: merchant_id)
    unless merchant.present? && merchant.state
      errors[:base] << "无效的merchant_id"
    end
  end

  def store_id_exists
    store = Store.find_by(id: store_id)
    unless store.present? && store.state
      errors[:base] << "无效的store_id"
    end
  end
end

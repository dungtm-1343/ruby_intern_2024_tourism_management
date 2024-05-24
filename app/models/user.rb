class User < ApplicationRecord
  ATTRIBUTES = %i(
    first_name
    last_name
    email
    password
    password_confirmation
  ).freeze

  enum role: {customer: 0, admin: 1}
  has_many :bookings, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :first_name, presence: true,
            length: {maximum: Settings.user.max_len_first_name}
  validates :last_name, presence: true,
            length: {maximum: Settings.user.max_len_last_name}

  before_save :downcase_email
  validates :email, presence: true,
                    length: {minimum: Settings.user.min_len_email,
                             maximum: Settings.user.max_len_email},
                    format: {with: Regexp.new(Settings.VALID_EMAIL_REGEX)},
                    uniqueness: {case_sensitive: false}

  validates :phone, format: {with: Regexp.new(Settings.VALID_PHONE_REGEX)},
                    allow_nil: true,
                    length: {minimum: Settings.user.min_len_phone,
                             maximum: Settings.user.max_len_phone}

  validates :address, length: {maximum: Settings.user.max_len_address}

  validates :password, presence: true,
                       length: {minimum: Settings.user.min_len_password},
                       if: :password

  has_secure_password

  attr_accessor :remember_token, :activation_token, :reset_token

  before_create :create_activation_digest

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create(string, cost:)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def forget
    update_column :remember_digest, nil
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest

    BCrypt::Password.new(digest).is_password? token
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token),
                   reset_sent_at: Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < Settings.time_reset_expired.hours.ago
  end

  private
  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end

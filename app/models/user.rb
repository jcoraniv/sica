class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { admin: 0, lecturador: 1, socio: 2, usuario: 3 }

  belongs_to :zone, optional: true
  belongs_to :category, optional: true

  has_many :meters, dependent: :restrict_with_exception
  has_many :readings, foreign_key: :lecturador_id, inverse_of: :lecturador, dependent: :restrict_with_exception
  has_many :invoices, dependent: :restrict_with_exception
  has_many :notifications, dependent: :destroy
  has_many :managed_payments, class_name: "Payment", foreign_key: :admin_id, inverse_of: :admin, dependent: :restrict_with_exception

  before_validation :normalize_username

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
  validates :phone, presence: true

  private

  def normalize_username
    self.username = username.to_s.strip.downcase
  end
end

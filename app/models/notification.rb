class Notification < ApplicationRecord
  belongs_to :user

  enum :kind, { reading: 0, meeting: 1, payment: 2 }

  validates :title, :body, presence: true
end

class Bank < ApplicationRecord
  has_many :accounts, dependent: :restrict_with_error
  has_many :transactions, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
end

class Bank < ApplicationRecord
  has_many :accounts
  has_many :transactions

  validates :name, presence: true, uniqueness: true
end

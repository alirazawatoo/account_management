class Account < ApplicationRecord
  has_many :transactions
  belongs_to :bank

  validates :name, presence: true, uniqueness: true
end

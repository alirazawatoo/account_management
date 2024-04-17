class Account < ApplicationRecord
  has_many :transactions, dependent: :restrict_with_error
  belongs_to :bank

  validates :name, presence: true, uniqueness: true
end

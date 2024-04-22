class Transaction < ApplicationRecord
  belongs_to :bank
  belongs_to :account

  validates :amount, :date, presence: true

  scope :duplicate_ids, -> { select('amount, group_concat(distinct transactions.id) as ids')
                             .group(:amount, :description)
                             .where("created_at >= Datetime('now', '-1 minute')") }

  before_save :populate_duplicate_ids

  def populate_duplicate_ids
    dup_transactions = self.class.duplicate_ids&.select{ |t| t.amount == amount }

    self.duplicate_ids = dup_transactions.pick('ids') if dup_transactions.present?
  end
end

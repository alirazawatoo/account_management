class Transaction < ApplicationRecord
  DUPLICATE_WINDOW = 1.minute

  belongs_to :bank
  belongs_to :account

  validates :amount, :date, presence: true

  before_create :flag_possible_duplicates

  def possible_duplicates
    return Transaction.none if duplicate_ids.blank?

    Transaction.where(id: duplicate_ids.split(","))
  end

  private

    # Flags, but never rejects, transactions on the same account that repeat the
    # amount and description within the window. Reviewers decide what is a real duplicate.
    def flag_possible_duplicates
      ids = Transaction.where(account_id: account_id, amount: amount, description: description)
                       .where(created_at: DUPLICATE_WINDOW.ago..)
                       .order(:id)
                       .pluck(:id)

      self.duplicate_ids = ids.join(",").presence
    end
end

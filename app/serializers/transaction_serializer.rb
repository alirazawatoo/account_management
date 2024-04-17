class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :amount, :date, :description, :flag_transactions

  def flag_transactions
    return if object.duplicate_ids.blank?

    object.possible_duplicates.map { |duplicate| duplicate.slice(:id, :amount, :date) }
  end
end

class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :amount, :date, :description, :flag_transactions

  def flag_transactions
    object.duplicate_ids && Transaction.where(id: object.duplicate_ids.split(',')).select(:id, :amount, :date)
  end
end

# SQLite stores an unscaled decimal as REAL, so SUM(amount) drifted (91.04 came back as
# 91.03999999999999). A fixed scale makes Active Record round values and sums to cents.
class SetScaleOnTransactionAmount < ActiveRecord::Migration[8.1]
  def up
    change_column :transactions, :amount, :decimal, precision: 15, scale: 2, null: false
  end

  def down
    change_column :transactions, :amount, :decimal, null: false
  end
end

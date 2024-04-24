class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.decimal :amount, null: false
      t.datetime :date, null: false
      t.text :description
      t.text :duplicate_ids, array: true, index: true

      t.references :account, foreign_key: true
      t.references :bank, foreign_key: true

      t.timestamps
    end
  end
end

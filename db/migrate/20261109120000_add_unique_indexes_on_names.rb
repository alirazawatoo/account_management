class AddUniqueIndexesOnNames < ActiveRecord::Migration[8.1]
  def change
    remove_index :banks, :name
    add_index :banks, :name, unique: true

    remove_index :accounts, :name
    add_index :accounts, :name, unique: true
  end
end

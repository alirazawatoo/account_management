# Demo data for local exploration. Safe to run more than once.
harbor = Bank.find_or_create_by!(name: "Harbor Savings")
northwind = Bank.find_or_create_by!(name: "Northwind Credit Union")

operating = harbor.accounts.find_or_create_by!(name: "Operating")
harbor.accounts.find_or_create_by!(name: "Payroll")
northwind.accounts.find_or_create_by!(name: "Reserve")

if operating.transactions.none?
  [
    { amount: "2500.00", description: "Client retainer", date: 3.days.ago },
    { amount: "-120.40", description: "Hosting invoice", date: 2.days.ago },
    { amount: "-120.40", description: "Hosting invoice", date: 2.days.ago }
  ].each { |attrs| operating.transactions.create!(attrs.merge(bank: harbor)) }
end

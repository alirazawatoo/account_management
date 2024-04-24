# Account Management API

A Rails JSON API for modeling banks, customer accounts, and account transactions. It provides nested transaction operations, calculates an account balance from transaction amounts, and records possible duplicate transactions created within a short time window.

## Domain model

```text
Bank
  └── has many Accounts
          └── has many Transactions

Transaction also stores its Bank association
```

Banks and accounts require unique names. Transactions require an amount and date, with an optional description.

## API

All routes return JSON under `/api/v1`.

| Method | Route | Purpose |
| --- | --- | --- |
| `GET` | `/banks` | List banks |
| `POST` | `/banks` | Create a bank |
| `PATCH` | `/banks/:id` | Update a bank |
| `DELETE` | `/banks/:id` | Delete a bank |
| `GET` | `/banks/:bank_id/accounts/:account_id/transactions` | List account transactions |
| `POST` | `/banks/:bank_id/accounts/:account_id/transactions` | Create a transaction |
| `PATCH` | `/banks/:bank_id/accounts/:account_id/transactions/:id` | Update a transaction |
| `DELETE` | `/banks/:bank_id/accounts/:account_id/transactions/:id` | Delete a transaction |
| `GET` | `/banks/:bank_id/accounts/:id/amount` | Sum transaction amounts |

### Create a transaction

```http
POST /api/v1/banks/1/accounts/2/transactions
Content-Type: application/json

{
  "amount": 125.50,
  "description": "Invoice payment",
  "date": "2024-04-24"
}
```

The account is resolved inside the supplied bank before the transaction is created, preventing a transaction route from silently crossing account boundaries.

## Duplicate-transaction indicator

Before a transaction is saved, the model queries recent records with matching amount and description and stores their identifiers in `duplicate_ids`. This is a review flag, not fraud detection: it uses a one-minute window and does not automatically reject a transaction.

## Project structure

```text
app/
├── controllers/api/v1/   # Nested JSON endpoints
├── models/               # Bank, account, and transaction rules
└── serializers/          # API response shapes
spec/
├── controllers/api/v1/   # Endpoint behavior
└── models/               # Associations and validation behavior
```

## Local setup

### Prerequisites

- Ruby 3.0
- Bundler
- SQLite

```bash
git clone https://github.com/alirazawatoo/account_management.git
cd account_management
bundle install
bin/rails db:setup
bin/rails server
```

The API is then available at `http://localhost:3000/api/v1`.

The tracked `db/schema.rb` is empty even though migrations define the domain tables. Run the migrations in a disposable development database and inspect the resulting schema before relying on seed or API behavior.

## Tests

```bash
bundle exec rspec
```

The repository includes model and controller specifications for banks, accounts, and transactions. This command is documented from the project configuration; no passing result is claimed here without execution.

## Current boundaries

- The API has no authentication or account ownership model.
- Duplicate detection is SQLite-specific and based only on recent amount/description matches.
- The amount endpoint returns an arithmetic sum rather than a ledger balance with debit/credit semantics.
- Database-level foreign keys and uniqueness constraints should be verified before production use.

## Next improvements

1. Introduce authenticated ownership and authorization rules.
2. Model transaction direction and immutable ledger entries explicitly.
3. Replace the duplicate query with database-portable matching and clear review states.
4. Add pagination and filtering to transaction lists.

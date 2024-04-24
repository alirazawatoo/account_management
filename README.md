## Dependencies
- Ruby 3.0.0
- Rails 6.1.4.1
- SQlite
- Rails API

## To setup project
- Install deps using `bundle install`
- Setup DB using `rails db:setup`
- Run `rails s` at project root, fire up the browser and go to `localhost:3000`
​

## Specs
- For rails specs `rspec`
​​

## Endpoints
 1. For Bank CRUD operations
    - GET `/api/v1/banks` retrieves all banks
    - POST `/api/v1/banks` for creation new bank record
    - PATCH `/api/v1/banks/:id` for update existing bank record
    - DELETE `/api/v1/banks/:id` for deletion of existing bank record
 2. For Transaction CRUD operations
    - GET `/api/v1/banks/:bank_id/accounts/:account_id/transactions` retrieves all transactions of an account
    - POST `/api/v1/banks/:bank_id/accounts/:account_id/transactions` for creation new transaction of an account
    - PATCH `/api/v1/banks/:bank_id/accounts/:account_id/transactions/:id` for update existing transaction record
    - DELETE `/api/v1/banks/:bank_id/accounts/:account_id/transactions/:id` for deletion of existing transaction record
 3. To get the total of all transaction amounts of an account
    - GET `/api/v1/banks/:bank_id/accounts/:id/amount` retrieve the total amount of all transactions of an account
​

## Explanations
- No authentication to keep things simple
- Added Model specs only
- Added unit test specs coverage
- We can see all flag transactions of a transaction with every endpoint of transaction CRUD operations

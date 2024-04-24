Rails.application.routes.draw do

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :banks, only: [:index, :create, :update, :destroy] do
        resources :accounts, only: [] do
          resources :transactions, only: [:index, :create, :update, :destroy]

          get :amount, on: :member
        end
      end
    end
  end
end

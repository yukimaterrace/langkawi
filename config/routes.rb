Rails.application.routes.draw do
  scope :api do
    post '/login', to: 'login#login'
    post '/logout', to: 'login#logout'

    resources :accounts
    resources :users, :except => [ :create, :destroy ]
  end
end

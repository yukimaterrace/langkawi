Rails.application.routes.draw do
  scope :api do
    post '/login', to: 'login#login'
    post '/logout', to: 'login#logout'

    resources :accounts
    resources :users, :except => [:create, :destroy]
    resources :user_details, :except => [:index, :show, :destroy] do
      post '/picture_a', to: 'user_details#upload_picture_a'
    end
    resources :relations, :except => [:show, :destroy]
    resources :talks, :except => [:show, :destroy]
  end
end

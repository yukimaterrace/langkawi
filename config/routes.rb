Rails.application.routes.draw do
  scope :api do
    get '/health_check', to: 'system#health_check'
    
    post '/login', to: 'login#login'
    post '/logout', to: 'login#logout'

    resources :accounts

    resources :users, :except => [:create, :destroy]

    resources :user_details, :except => [:index, :show, :destroy] do
      post '/picture_a', to: 'user_details#upload_picture_a'
    end
    resources :relations, :except => [:destroy]

    resources :talks, :except => [:show, :destroy]
    get '/talks/rooms', to: 'talks#index_rooms'
  end
end

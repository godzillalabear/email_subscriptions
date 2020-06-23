require 'sidekiq/web'

Rails.application.routes.draw do
  
  resources :projects do
    resources :tasks
  end
    
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users
  
  match "/users/unsubscribe/:unsubscribe_hash" => "emails#unsubscribe", as: "unsubscribe", via: :all

  devise_scope :user do
    authenticated :user do
      root "projects#index"
    end

    unauthenticated do
      root "home#index", as: :unauthenticated_root
    end
  end
end

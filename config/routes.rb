Rails.application.routes.draw do
  devise_for :users,
             controllers: { omniauth_callbacks: 'user/omniauth_callbacks' }

  root to: 'user#show'

  resource :user
  resource :search, only: :show, controller: :search
  resources :messages, except: %i[edit update]
  resources :playlists, only: %i[create destroy]
end

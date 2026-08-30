# frozen_string_literal: true

Rails.application.routes.draw do
  resource :session, only: %i[new create destroy]
  resources :current_incomes, only: %i[index new create]
  resources :invoices, only: %i[index show edit update destroy] do
    get :paid, on: :collection
  end
  resources :bills
  resources :incomes, except: %i[show]
  resources :expenses, except: %i[show]
  resource :statement, only: %i[show]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*. Both are public: the manifest and the service
  # worker are fetched before there is any session to authenticate with.
  get 'manifest' => 'rails/pwa#manifest', as: :pwa_manifest
  # The layout asks for the manifest as /manifest.json, but the service worker is fetched by the
  # browser at a fixed extensionless path, so its format has to be pinned here instead.
  get 'service-worker' => 'rails/pwa#service_worker', as: :pwa_service_worker, defaults: { format: :js }

  # Defines the root path route ("/")
  root 'home#index'

  mount MissionControl::Jobs::Engine, at: '/jobs'
end

Rails.application.routes.draw do
  root to: 'dashboard#index'
  devise_for :users, controllers: { registrations: 'registrations', sessions: 'sessions', passwords: 'passwords' }

  get '/dashboard' => 'dashboard#index'
  get '/robots.txt' => 'dashboard#robots'
  get '/data_trackers' => 'data_trackers#index'

  resources :clients, only: [:index]

  scope 'admin' do
    resources :users do
      get 'version' => 'users#version'
      get 'disable' => 'users#disable'
    end
  end
end

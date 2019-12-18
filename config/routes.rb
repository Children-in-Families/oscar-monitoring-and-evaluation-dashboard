Rails.application.routes.draw do
  root to: 'donors#index'

  devise_for :users, controllers: { registrations: 'registrations', sessions: 'sessions', passwords: 'passwords' }

  get '/robots.txt' => 'donors#robots'
  get '/dashboards' => 'dashboards#index'
  get '/robots.txt' => 'dashboards#robots'
  get '/data_trackers' => 'data_trackers#index'

  resources :clients, only: [:index]

  scope 'admin' do
    resources :users do
      get 'version' => 'users#version'
      get 'disable' => 'users#disable'
    end
  end
end

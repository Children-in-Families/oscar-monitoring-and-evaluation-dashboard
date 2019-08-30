Rails.application.routes.draw do
  root to: 'dashboard#index'
  get '/dashboard' => 'dashboard#index'

  devise_for :users, controllers: { registrations: 'registrations', sessions: 'sessions', passwords: 'passwords' }

  get '/robots.txt' => 'dashboard#robots'

  resources :clients, only: [:index]
  scope 'admin' do
    resources :users
  end
end

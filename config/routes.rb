Rails.application.routes.draw do

  root 'roots#top'

  devise_for :admins, controllers: {
    sessions:      'admins/sessions',
    passwords:     'admins/passwords',
    registrations: 'admins/registrations'
  }
  scope "companies/:name" do
    devise_for :users, controllers: {
      sessions:      'users/sessions',
      passwords:     'users/passwords',
      registrations: 'users/registrations',
      confirmations: 'users/confirmations'
    }
  end

  namespace :admins do
    resources :companies, param: :name do
      resources :surveys, only: [:index, :show]
    end
    resources :surveys, only: [:new, :create] do
      resources :questions, only: [:new, :create]
    end
  end

  resources :companies, param: :name, only: [] do
    resources :users, only: [:index, :delete]
    resources :surveys, only: [:index, :show] do
      member do
        get :answer_new
        post :answer_create
      end
    end
  end

  resources :users, only: :show do
    resources :messages, only: [:new, :create]
  end

end


Rails.application.routes.draw do

  devise_for :admins, controllers: {
    sessions:      'admins/sessions',
    passwords:     'admins/passwords',
    registrations: 'admins/registrations'
  }
  scope "companies/:name" do
    devise_for :users, controllers: {
      sessions:      'users/sessions',
      passwords:     'users/passwords',
      registrations: 'users/registrations'
    }
  end

  namespace :admins do
    resources :campanies
    resources :surveys, only: [:new, :create] do
      resources :questions, only: [:new, :create]
    end
  end

  namespace :mains do
    resources :users, only: [:index, :delete]
  end

  resources :companies, only: [] do
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


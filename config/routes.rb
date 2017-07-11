Rails.application.routes.draw do

  devise_for :admins, controllers: {
    sessions:      'admins/sessions',
    passwords:     'admins/passwords',
    registrations: 'admins/registrations'
  }
  scope "companies/:company_id" do
    devise_for :users, controllers: {
      sessions:      'users/sessions',
      passwords:     'users/passwords',
      registrations: 'users/registrations'
    }
  end

  root 'root#top'
  get 'search' => 'root#search'

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
    collection do
      get :search
    end
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


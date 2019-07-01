Rails.application.routes.draw do
  namespace :admin do
    resources :users
    resources :companies
    resources :clients
    resources :projects
    resources :time_tracks
    root to: "users#index"
  end
  root to: 'visitors#index'
  get '/reports' => 'visitors#reports'
  get '/export' => 'visitors#export'
  devise_for :users, :controllers => {:registrations => "registrations"}

  resources :companies do
    member do
      delete :destroy_member
      post :invite_to
      delete :destroy_invite
      get :edit_member
      post :update_member
    end
  end
  resources :clients
  resources :projects
  resources :time_tracks do
    collection do
      get :label_search
    end
  end
  resources :users do
    collection do
      get :search
    end
  end

end

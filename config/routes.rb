Rails.application.routes.draw do
  # Authentication routes
  post "/signup",   to: "registrations#create"
  post "/login",    to: "sessions#create"
  post "/refresh",  to: "sessions#refresh"
  delete "/logout", to: "sessions#destroy"

  # Password reset routes
  post "/password/forgot", to: "passwords#forgot"
  post "/password/reset",  to: "passwords#reset"
  
  # Profile routes
  resource :profile, only: [:show, :update]
  
  # Workout routes (regular users can only view, not update)
  resources :workouts, only: [:index, :show]
  
  # Favorites routes (note: controller is actually named 'favourites')
  resources :favourites, only: [:index, :create, :destroy], path: 'favorites'
  
  # Selections (history) routes
  resources :selections, only: [:index, :create]

  # Analytics routes
  get "/me/most_selected_workouts", to: "analytics#most_selected_me"
  get "/analytics/most_selected",   to: "analytics#most_selected"

  # Recommendations routes
  get "/recommendations/trending",     to: "recommendations#trending"       # global trending
  get "/recommendations/personalized", to: "recommendations#personalized"   # per-user


  # Todo routes
  resources :todos

  # Admin namespace
  namespace :admin do
    get "workouts/index"
    get "workouts/show"
    get "workouts/create"
    get "workouts/update"
    get "workouts/destroy"
    get "workouts/showuser"
    resources :workouts
  end
end

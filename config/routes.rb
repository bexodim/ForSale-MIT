OdimProj2::Application.routes.draw do
  
  
  get '/login' => 'sessions#new', :as => 'login'
  get '/logout' => 'sessions#destroy', :as => 'logout'
  get '/signup' => 'users#new', :as => 'signup'
  get '/users/:id/bag' => 'users#bag', :as => 'bag'
  get '/users/:id/room' => 'users#room', :as => 'room'
  ##get '/history' => 'users#history', :as => 'history'
  get '/users/:id/addto' => 'items#addto', :as => 'addto'
  get '/users/:id/removefrom' => 'items#removefrom', :as => 'removefrom'
  get '/checkout' => 'items#checkout', :as => 'checkout'
  ##delete '/items/:id/removephoto' => 'items#removephoto', :as => 'removephoto'
 
  
  resources :sessions, :only => [:create]
  resources :items
  resources :users

  root :to => 'sessions#new'

end

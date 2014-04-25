Rails.application.routes.draw do

  # get 'home/index'
  
  match ':controller(/:action(/:id))', :via => :get

  root 'home#index'
end

Rails.application.routes.draw do
  devise_for :users, :controllers => {home: "/"}

  root :to => 'home#index'
end

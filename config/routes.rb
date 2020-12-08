Rails.application.routes.draw do
  resources :documents, only: [:index]
end

Rails.application.routes.draw do
  resource :documents, only: [:show, :update]
end

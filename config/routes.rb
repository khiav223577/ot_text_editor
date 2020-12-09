Rails.application.routes.draw do
  resource :documents, only: [:show, :update] do
    get :operation
  end
end

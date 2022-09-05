Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :restaurants do
        resources :foods, only: %i[ index ]
    end
      resources :line_fooks, only: %i[ index create ]
      put 'line_foods',to: 'line_foods#replace'
      resources :order, only: %i[ create ]
    end
  end
end

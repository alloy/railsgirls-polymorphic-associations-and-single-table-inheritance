Rails.application.routes.draw do
  resources :invoices
  resources :music_events
  resources :sport_events

  root 'sport_events#index'
end

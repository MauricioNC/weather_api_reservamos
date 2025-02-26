Rails.application.routes.draw do
  root to: "home#index"

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  post "weather", to: "weathers#by_city"
end

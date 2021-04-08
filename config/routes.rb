# frozen_string_literal: true

Rails.application.routes.draw do
  root "venue_platforms#index"

  resources :venue_platforms, only: [:index, :show, :update]

  resources :bulk_platform, only: [:index]
  patch "/bulk_platform", to: "bulk_platform#update"
end
